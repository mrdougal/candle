#include <ruby.h>
#include <ruby/encoding.h>

#include <CoreServices/CoreServices.h>


#define RELEASE_IF_NOT_NULL(ref) { if (ref) { CFRelease(ref); } }





// Convert a ruby string into a c string
static CFStringRef rbstr2cfstring(VALUE str) {
	
	return CFStringCreateWithCString(kCFAllocatorDefault, StringValuePtr(str), kCFStringEncodingUTF8);
	
}

// Convert a c string into a ruby string
static VALUE cfstring2rbstr(CFStringRef str) {
	
	// Pointer to store output
	const char *result;
	
	// Set default value for return result to nil
	VALUE rb_result = Qnil;
	
	
	//	Create an “external representation” of a CFString object
	//
	//	CFDataRef CFStringCreateExternalRepresentation (
	//													CFAllocatorRef alloc,
	//													CFStringRef theString,
	//													CFStringEncoding encoding,
	//													UInt8 lossByte
	//													);
	//
	CFDataRef data = CFStringCreateExternalRepresentation(kCFAllocatorDefault, str, kCFStringEncodingUTF8, 0);
	
	// Assuming we get something back...
	if (data) {
		
		
		//		Returns a read-only pointer to the bytes of a CFData object.
		//		
		//		const UInt8 * CFDataGetBytePtr (
		//										CFDataRef theData
		//										);
		//		
		result = (const char *)CFDataGetBytePtr(data);
		
		if(result) {

			// Return a new ruby string 
			rb_result = rb_str_new2(result);

			// Convert the encoding to UTF-8
			int enc = rb_enc_find_index("UTF-8");

			rb_enc_associate_index(rb_result, enc);

		}
	}
	
	
	RELEASE_IF_NOT_NULL(data)
	return rb_result;
	
}


// Convert objects such as strings, array etc into their ruby equivalent
// Method is passed a type identifier from Core Foundation which the result from Spotlight
static VALUE convert2rb_type(CFTypeRef ref) {
	
	VALUE result = Qnil;
	
	int number_type;
	
	double double_result;
	float float_result;
	int int_result;
	long long_result;
	int i;
	
	if (ref) {
		
		// Detect what type of Reference was passed in
		// then we will convert each variant into a Ruby object
		
		
		// Detect for String
		if (CFGetTypeID(ref) == CFStringGetTypeID()) {
			result = cfstring2rbstr(ref);
			
			
		// Detect for Date
		} else if (CFGetTypeID(ref) == CFDateGetTypeID()) {
			
			// 978307200.0 == (January 1, 2001 00:00 GMT) - (January 1, 1970 00:00 UTC)
			// CFAbsoluteTime => January 1, 2001 00:00 GMT
			// ruby Time => January 1, 1970 00:00 UTC
			double_result = (double) CFDateGetAbsoluteTime(ref) + 978307200;
			result = rb_funcall(rb_cTime, rb_intern("at"), 1, rb_float_new(double_result));
			
			
		// Detect for Array
		} else if (CFGetTypeID(ref) == CFArrayGetTypeID()) {
			
			
			// Create a ruby array
			result = rb_ary_new();
			
			// Loop through our results from C
			for (i = 0; i < CFArrayGetCount(ref); i++) {
				
				// Push our result onto the ruby array 
				// once we've converted it to a ruby type
				rb_ary_push(result, convert2rb_type(CFArrayGetValueAtIndex(ref, i)));
			}
			
			// Detection for Number
		} else if (CFGetTypeID(ref) == CFNumberGetTypeID()) {
			
			
			// Detect for Float
			if (CFNumberIsFloatType(ref)) {
				
				
				// CFNumberGetValue
				// Obtains the value of a CFNumber object cast to a specified type
				//
				// Types of numbers available and their codes
				// 
				// 	kCFNumberSInt8Type = 1,
				// 	kCFNumberSInt16Type = 2,
				// 	kCFNumberSInt32Type = 3,
				// 	kCFNumberSInt64Type = 4,
				// 	kCFNumberFloat32Type = 5,
				// 	kCFNumberFloat64Type = 6,
				// 	kCFNumberCharType = 7,
				// 	kCFNumberShortType = 8,
				// 	kCFNumberIntType = 9,
				// 	kCFNumberLongType = 10,
				// 	kCFNumberLongLongType = 11,
				// 	kCFNumberFloatType = 12,
				// 	kCFNumberDoubleType = 13,
				// 	kCFNumberCFIndexType = 14,
				// 	kCFNumberNSIntegerType = 15,
				// 	kCFNumberCGFloatType = 16,
				// 	kCFNumberMaxType = 16
				
				// CFNumberGetType
				// Returns the type used by a CFNumber object to store its value.
				
				
				// Get the value of the number (based on how it is stored)
				// with the result being stored 'double_result'
				
				
				number_type = CFNumberGetType(ref);
				
				if(number_type == 6)
				{
					// There is an issue with creating 64 bit floats in ruby
					// so we'll only make 32 bit float numbers
					// 2010-12-27
					// This doesn't feel like the right thing to do but it's working
					
					number_type = 5;
				}

				
				CFNumberGetValue(ref, number_type, &float_result);
				
				result = rb_float_new(float_result);

			} else {
				
				// Number isn't a Float so we'll return a 'Long' 

				CFNumberGetValue(ref, CFNumberGetType(ref), &long_result);
				result = INT2NUM(long_result);
				
			}
		}
	}
	
	return result;
	
}





// This is where we ask Spotlight for the metadata
// (called from method_attributes)
static MDItemRef get_metadata_from_path(VALUE path) {
	
	
	// Need to convert the ruby string into a C string that we can pass to Spotlight
	CFStringRef pathRef = rbstr2cfstring(path);
	
	// Create our MetaData object from Spotlight
	MDItemRef inspectedRef = MDItemCreate(kCFAllocatorDefault, pathRef);
	
	RELEASE_IF_NOT_NULL(pathRef);
	
	
	if(!inspectedRef) {
		
		// Raise an error in Ruby saying that we could find the asset
		rb_raise(rb_eTypeError, "Candle::Spotlight Could not find asset by given path");
	}
	
	return inspectedRef;
	
}



// Retrieves metadata from the file
// This is called from ruby
VALUE get_metadata(VALUE self, VALUE path) {
	

	int i;

    CFArrayRef       inspectedRefAttributeNames;
    CFDictionaryRef  inspectedRefAttributeValues;

	CFStringRef      attributeName;
	CFDictionaryRef  attributeValue;
    


	// Retrieve a Metadata object from the path
	// Will raise an error if is unable to ready the file
	MDItemRef inspectedRef = get_metadata_from_path(path);
	
	
	// Extract values from the metadata object
	inspectedRefAttributeNames = MDItemCopyAttributeNames(inspectedRef);
    inspectedRefAttributeValues = MDItemCopyAttributes(inspectedRef,inspectedRefAttributeNames);;
    
  
	// Ruby hash to store our results and ultimately return back to ruby
	VALUE result = rb_hash_new();
	
	
	for(i = 0; i < CFArrayGetCount(inspectedRefAttributeNames); ++i) {

		// Extract our key value pair
	    attributeName = CFArrayGetValueAtIndex(inspectedRefAttributeNames,i);
		attributeValue = CFDictionaryGetValue(inspectedRefAttributeValues,attributeName); 


		// Assign key and values to our ruby hash (result)
		rb_hash_aset(result, cfstring2rbstr(attributeName), convert2rb_type(attributeValue));
			
	    // RELEASE_IF_NOT_NULL(attributeValue);
	
	}
	
	RELEASE_IF_NOT_NULL(inspectedRef);
	RELEASE_IF_NOT_NULL(inspectedRefAttributeNames);
	RELEASE_IF_NOT_NULL(inspectedRefAttributeValues);
	

	return result;
	
}




//	This is called first as the bundle is called 'candle'
// We setup a class Spotlight contained within the Candle model
void Init_spotlight (void) {
	
	// Define a new module at the top level
	VALUE Candle = rb_define_module("Candle");
	
	// Define a nested class under the supplied class or module
	// Which in this case is 'spotlight'
	VALUE Spotlight = rb_define_module_under(Candle, "Spotlight");
	
	// Defines a method that can be called from Ruby
	// In this case 'attributes' can be called which calls 
	// 'method_attriubtes' in our C extension
	rb_define_module_function(Spotlight, "attributes", get_metadata, 1);
	
}
