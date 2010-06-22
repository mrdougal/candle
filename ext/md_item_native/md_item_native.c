#include "md_item_native.h"

static VALUE rb_cMDItemNative;

struct ItemObject {
	MDItemRef item;
};

CFStringRef CString2CFString(char *str) {
	return CFStringCreateWithCString(kCFAllocatorDefault,
		str,
		kCFStringEncodingUTF8);
}

VALUE CFString2RString(CFStringRef str) {
	int stringSize;
	char *tmpptr;
	VALUE result;

	stringSize = CFStringGetMaximumSizeForEncoding(CFStringGetLength(str), kCFStringEncodingUTF8) + 1;
	tmpptr = (char *)malloc(sizeof(char) * stringSize);
	CFStringGetCString(str, tmpptr, stringSize, kCFStringEncodingUTF8);
	result = rb_str_new2(tmpptr);
	free(tmpptr);

	return result;
}

VALUE CFType2Value(CFTypeRef thing) {
	int i;
	double doubleValue;
	CFNumberType numberType;
	CFAbsoluteTime timeNow;
	CFGregorianDate current;
	VALUE result;

/*   CFStringRef stringValue = CFCopyDescription(thing); */
/*   rb_p(CFString2RString(stringValue)); */
/*   CFRelease(stringValue); */

	if(CFGetTypeID(thing) == CFStringGetTypeID()) {
		result = CFString2RString((CFStringRef)thing);
	} else if(CFGetTypeID(thing) == CFNumberGetTypeID()) {
		numberType = CFNumberGetType((CFNumberRef)thing);
		switch(numberType) {
			case kCFNumberFloat64Type:
			CFNumberGetValue((CFNumberRef)thing, numberType, &doubleValue);
			result = rb_float_new(doubleValue);
			break;
			case kCFNumberSInt32Type:
			case kCFNumberSInt64Type:
			default:
			CFNumberGetValue((CFNumberRef)thing, kCFNumberDoubleType, &doubleValue);
			result = INT2FIX((double)doubleValue);
			break;
		}
	} else if(CFGetTypeID(thing) == CFDateGetTypeID()) {
		timeNow = CFDateGetAbsoluteTime((CFDateRef)thing);
		current = CFAbsoluteTimeGetGregorianDate(timeNow, NULL);
		result = rb_funcall(rb_cTime, rb_intern("gm"), 6,
			INT2FIX((unsigned int)current.year),
			INT2FIX((unsigned int)current.month),
			INT2FIX((unsigned int)current.day),
			INT2FIX((unsigned int)current.hour),
			INT2FIX((unsigned int)current.minute),
			INT2FIX((unsigned int)current.second));
	} else if(CFGetTypeID(thing) == CFBooleanGetTypeID()) {
		result = CFBooleanGetValue(thing) ? Qtrue : Qfalse;
	} else if(CFGetTypeID(thing) == CFArrayGetTypeID()) {
		result = rb_ary_new();
		for(i = 0; i < CFArrayGetCount(thing); i ++) {
			rb_ary_push(result, CFType2Value(CFArrayGetValueAtIndex(thing, i)));
		}
	} else {
		result = Qnil;
	}

	return result;
}

MDItemRef getItem(VALUE obj) {
	struct ItemObject *itemObject;

	Data_Get_Struct(obj, struct ItemObject, itemObject);
	return itemObject->item;
}

void cMDItemNative_free(void *ptr) {
	MDItemRef item = (MDItemRef)(((struct ItemObject *)ptr)->item);

	if(item != NULL) {
		CFRelease(item);
	}

	free(ptr);

}

VALUE createInstanceFromMDItem(MDItemRef item) {
	struct ItemObject *itemObject;

	itemObject = malloc(sizeof(struct ItemObject));
	itemObject->item = item;

	return Data_Wrap_Struct(rb_cMDItemNative, 0, cMDItemNative_free, itemObject);
}

static VALUE cMDItemNative_new(int argc, VALUE *argv, VALUE klass)
{
	VALUE filename, obj;
	MDItemRef item;
	CFStringRef cfFilename;

	// Scans the argument list and assigns to variables
	// The first digit indicate the count of mandatory arguments
	// The secound the count of optional arguments
	//  * means that an attached code block will be taken and assigned to the given variable
	rb_scan_args(argc, argv, "1", &filename);

	// Assign the file to a CFString object (as required by Spotlight)
	// Via the Ruy convenience method StringValueStr which resolves the string reference
	// and returns the C pointer to the contents
	cfFilename = CString2CFString(StringValuePtr(filename));
	
	// Create an MDItem from the path of the filename
	// A MDItem represents a file and the metadata associated with the file
	item = MDItemCreate(kCFAllocatorDefault, cfFilename);

	if(item != NULL) {

		// We had something returned
		obj = createInstanceFromMDItem(item);
	} else {
		// Raises an exception (in Ruby)
		rb_raise(rb_eArgError, "no such file or directory: %s", filename);
	}

	CFRelease(cfFilename);

	return obj;
}

static VALUE cMDItemNative_get(int argc, VALUE *argv, VALUE self)
{
	MDItemRef item = getItem(self);
	CFTypeRef itemValue;
	CFStringRef cfAttrName;
	VALUE attrName, result;

	rb_scan_args(argc, argv, "1", &attrName);

	if(TYPE(attrName) == T_SYMBOL) {
		cfAttrName = (CFStringRef)CString2CFString(rb_id2name(SYM2ID(attrName)));
	} else {
		cfAttrName = (CFStringRef)CString2CFString(StringValuePtr(attrName));
	}

	itemValue = MDItemCopyAttribute(item, cfAttrName);

	CFRelease(cfAttrName);

	if(itemValue != NULL) {
		result = CFType2Value(itemValue);
		CFRelease(itemValue);
		return result;
	}

	return Qnil;
}

static VALUE cMDItemNative_attribute_names(int argc, VALUE *argv, VALUE self)
{
	MDItemRef item = getItem(self);
	CFArrayRef cfAttributeNames;
	VALUE result = rb_ary_new();
	int numAttributes, i;

	rb_scan_args(argc, argv, "0");

	cfAttributeNames = MDItemCopyAttributeNames(item);

	if(cfAttributeNames != NULL) {
		numAttributes = (int)CFArrayGetCount(cfAttributeNames);
		for(i = 0; i < numAttributes; i ++) {
			
			rb_ary_push(result, CFString2RString((CFStringRef)CFArrayGetValueAtIndex(cfAttributeNames, i)));
		}
	}

	// Release from memory
	CFRelease(cfAttributeNames);

	return result;
}


// This is called first, as the bundle is called 'md_item_native'
void Init_md_item_native(void){
	VALUE rb_mCandle;

	// Define a new module at the top level
	rb_mCandle = rb_define_module("Candle");

	// Define a nested class under the suplided class or module
	rb_cMDItemNative = rb_define_class_under(rb_mCandle, "MDItemNative", rb_cObject);

	// Defines a singleton (class) method with the given name
	// In this instance we are setting new
	rb_define_singleton_method(rb_cMDItemNative, "new", cMDItemNative_new, -1);

	// Defining instance methods 
	rb_define_method(rb_cMDItemNative, "get", cMDItemNative_get, -1);
	rb_define_method(rb_cMDItemNative, "attribute_names", cMDItemNative_attribute_names, -1);
}
