#include <ruby.h>
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
	
	// Set default value for retrun result to nil
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
		
		// Return a new ruby string 
		rb_result = rb_str_new2(result);
	}
	RELEASE_IF_NOT_NULL(data)
	return rb_result;
}



// Called from method_attributes 
static MDItemRef createMDItemFromPath(VALUE path) {
	
	// Need to convert the ruby string
	CFStringRef pathRef = rbstr2cfstring(path);
	
	// Create our MetaData object
	MDItemRef mdi = MDItemCreate(kCFAllocatorDefault, pathRef);
	
	RELEASE_IF_NOT_NULL(pathRef);
	
	// If there is nothing returned from the request to find our MetaData object
	if (!mdi) {
		// Raise an error in Ruby
		rb_raise(rb_eTypeError, "Could not find MDItem by given path");
	}
	
	// return our MetaData object for processing
	return mdi;
}


static VALUE convert2rb_type(CFTypeRef ref) {

  VALUE result = Qnil;

  double double_result;
  int int_result;
  long long_result;
  int i;

  if (ref) {

    if (CFGetTypeID(ref) == CFStringGetTypeID()) {
      result = cfstring2rbstr(ref);

    } else if (CFGetTypeID(ref) == CFDateGetTypeID()) {
	
      // 978307200.0 == (January 1, 2001 00:00 GMT) - (January 1, 1970 00:00 UTC)
      // CFAbsoluteTime => January 1, 2001 00:00 GMT
      // ruby Time => January 1, 1970 00:00 UTC
      double_result = (double) CFDateGetAbsoluteTime(ref) + 978307200;
      result = rb_funcall(rb_cTime, rb_intern("at"), 1, rb_float_new(double_result));

    } else if (CFGetTypeID(ref) == CFArrayGetTypeID()) {

      result = rb_ary_new();
      for (i = 0; i < CFArrayGetCount(ref); i++) {
        rb_ary_push(result, convert2rb_type(CFArrayGetValueAtIndex(ref, i)));
      }
    } else if (CFGetTypeID(ref) == CFNumberGetTypeID()) {

      if (CFNumberIsFloatType(ref)) {

        CFNumberGetValue(ref, CFNumberGetType(ref), &double_result);
        result = rb_float_new(double_result);
      } else {
        CFNumberGetValue(ref, CFNumberGetType(ref), &long_result);
        result = LONG2NUM(long_result);
      }
    }
  }

  return result;

}



// This defines the attributes method in ruby
VALUE method_attributes(VALUE self, VALUE path) {
	
	
	int i;
	
	CFStringRef attrNameRef;
	CFTypeRef attrValueRef;
	
	// Get a MetaData object from our path
	MDItemRef mdi = createMDItemFromPath(path);
	
	// Get an array of the attribute names
	CFArrayRef attrNamesRef = MDItemCopyAttributeNames(mdi);
	
	// Create a ruby hash to store our MetaData information
	// and ultimately send back to Ruby
	VALUE result = rb_hash_new();
	
	// Cycle through the attributes and populate our results hash
	for (i = 0; i < CFArrayGetCount(attrNamesRef); i++) {
		
		// Building our name value pairs
		attrNameRef = CFArrayGetValueAtIndex(attrNamesRef, i);
		attrValueRef = MDItemCopyAttribute(mdi, attrNameRef);
		
		// Set key value pair in the ruby hash
		// Note that we need to convert the C strings back into ruby strings
		rb_hash_aset(result, cfstring2rbstr(attrNameRef), convert2rb_type(attrValueRef));
		
		
		RELEASE_IF_NOT_NULL(attrValueRef);
	}
	
	RELEASE_IF_NOT_NULL(mdi);
	RELEASE_IF_NOT_NULL(attrNamesRef);
	
	return result;
}



//	This is called first as the bundle is called 'candle'
void Init_candle (void) {
	
	// Define a new module at the top level
	VALUE Candle = rb_define_module("Candle");
	
	// Define a nested class under the supplied class or module
	VALUE CandleIntern = rb_define_module_under(Candle, "Intern");

	// Defines a method in module
	rb_define_module_function(CandleIntern, "attributes", method_attributes, 1);

}
