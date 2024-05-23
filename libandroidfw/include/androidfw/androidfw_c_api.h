#ifndef __ANDROIDFW_C_API_H
#define __ANDROIDFW_C_API_H

#include <stdint.h>
#include <stdbool.h>
#include <uchar.h>
#include <sys/types.h>

#ifdef __cplusplus
extern "C" {
#endif

#define Res_MAKEINTERNAL(entry) (0x01000000 | (entry&0xFFFF))

struct AssetManager;
struct ResTable;
struct ResStringPool;
struct Theme;
struct Asset;
struct ResXMLTree;
struct ResXMLParser;

// Type of the data value.
enum {
    // The 'data' is either 0 or 1, specifying this resource is either
    // undefined or empty, respectively.
    TYPE_NULL = 0x00,
    // The 'data' holds a ResTable_ref, a reference to another resource
    // table entry.
    TYPE_REFERENCE = 0x01,
    // The 'data' holds an attribute resource identifier.
    TYPE_ATTRIBUTE = 0x02,
    // The 'data' holds an index into the containing resource table's
    // global value string pool.
    TYPE_STRING = 0x03,
    // The 'data' holds a single-precision floating point number.
    TYPE_FLOAT = 0x04,
    // The 'data' holds a complex number encoding a dimension value,
    // such as "100in".
    TYPE_DIMENSION = 0x05,
    // The 'data' holds a complex number encoding a fraction of a
    // container.
    TYPE_FRACTION = 0x06,
    // The 'data' holds a dynamic ResTable_ref, which needs to be
    // resolved before it can be used like a TYPE_REFERENCE.
    TYPE_DYNAMIC_REFERENCE = 0x07,
    // The 'data' holds an attribute resource identifier, which needs to be resolved
    // before it can be used like a TYPE_ATTRIBUTE.
    TYPE_DYNAMIC_ATTRIBUTE = 0x08,

    // Beginning of integer flavors...
    TYPE_FIRST_INT = 0x10,

    // The 'data' is a raw integer value of the form n..n.
    TYPE_INT_DEC = 0x10,
    // The 'data' is a raw integer value of the form 0xn..n.
    TYPE_INT_HEX = 0x11,
    // The 'data' is either 0 or 1, for input "false" or "true" respectively.
    TYPE_INT_BOOLEAN = 0x12,

    // Beginning of color integer flavors...
    TYPE_FIRST_COLOR_INT = 0x1c,

    // The 'data' is a raw integer value of the form #aarrggbb.
    TYPE_INT_COLOR_ARGB8 = 0x1c,
    // The 'data' is a raw integer value of the form #rrggbb.
    TYPE_INT_COLOR_RGB8 = 0x1d,
    // The 'data' is a raw integer value of the form #argb.
    TYPE_INT_COLOR_ARGB4 = 0x1e,
    // The 'data' is a raw integer value of the form #rgb.
    TYPE_INT_COLOR_RGB4 = 0x1f,

    // ...end of integer flavors.
    TYPE_LAST_COLOR_INT = 0x1f,

    // ...end of integer flavors.
    TYPE_LAST_INT = 0x1f
};

// Structure of complex data values (TYPE_UNIT and TYPE_FRACTION)
enum {
    // Where the unit type information is.  This gives us 16 possible
    // types, as defined below.
    COMPLEX_UNIT_SHIFT = 0,
    COMPLEX_UNIT_MASK = 0xf,

    // TYPE_DIMENSION: Value is raw pixels.
    COMPLEX_UNIT_PX = 0,
    // TYPE_DIMENSION: Value is Device Independent Pixels.
    COMPLEX_UNIT_DIP = 1,
    // TYPE_DIMENSION: Value is a Scaled device independent Pixels.
    COMPLEX_UNIT_SP = 2,
    // TYPE_DIMENSION: Value is in points.
    COMPLEX_UNIT_PT = 3,
    // TYPE_DIMENSION: Value is in inches.
    COMPLEX_UNIT_IN = 4,
    // TYPE_DIMENSION: Value is in millimeters.
    COMPLEX_UNIT_MM = 5,

    // TYPE_FRACTION: A basic fraction of the overall size.
    COMPLEX_UNIT_FRACTION = 0,
    // TYPE_FRACTION: A fraction of the parent size.
    COMPLEX_UNIT_FRACTION_PARENT = 1,

    // Where the radix information is, telling where the decimal place
    // appears in the mantissa.  This give us 4 possible fixed point
    // representations as defined below.
    COMPLEX_RADIX_SHIFT = 4,
    COMPLEX_RADIX_MASK = 0x3,

    // The mantissa is an integral number -- i.e., 0xnnnnnn.0
    COMPLEX_RADIX_23p0 = 0,
    // The mantissa magnitude is 16 bits -- i.e, 0xnnnn.nn
    COMPLEX_RADIX_16p7 = 1,
    // The mantissa magnitude is 8 bits -- i.e, 0xnn.nnnn
    COMPLEX_RADIX_8p15 = 2,
    // The mantissa magnitude is 0 bits -- i.e, 0x0.nnnnnn
    COMPLEX_RADIX_0p23 = 3,

    // Where the actual value is.  This gives us 23 bits of
    // precision.  The top bit is the sign.
    COMPLEX_MANTISSA_SHIFT = 8,
    COMPLEX_MANTISSA_MASK = 0xffffff
};

// Possible data values for TYPE_NULL.
enum {
    // The value is not defined.
    DATA_NULL_UNDEFINED = 0,
    // The value is explicitly defined as empty.
    DATA_NULL_EMPTY = 1
};

struct Res_value
{
    // Number of bytes in this structure.
    uint16_t size;

    // Always set to 0.
    uint8_t res0;
    uint8_t dataType;

    // The data for this item, as interpreted according to dataType.
    uint32_t data;
};

/**
 *  This is a reference to a unique entry (a ResTable_entry structure)
 *  in a resource table.  The value is structured as: 0xpptteeee,
 *  where pp is the package index, tt is the type index in that
 *  package, and eeee is the entry index in that type.  The package
 *  and type values start at 1 for the first item, to help catch cases
 *  where they have not been supplied.
 */
struct ResTable_ref
{
    uint32_t ident;
};

// Special values for 'name' when defining attribute resources.
enum {
    // This entry holds the attribute's type code.
    ATTR_TYPE = Res_MAKEINTERNAL(0),

    // For integral attributes, this is the minimum value it can hold.
    ATTR_MIN = Res_MAKEINTERNAL(1),

    // For integral attributes, this is the maximum value it can hold.
    ATTR_MAX = Res_MAKEINTERNAL(2),

    // Localization of this resource is can be encouraged or required with
    // an aapt flag if this is set
    ATTR_L10N = Res_MAKEINTERNAL(3),

    // for plural support, see android.content.res.PluralRules#attrForQuantity(int)
    ATTR_OTHER = Res_MAKEINTERNAL(4),
    ATTR_ZERO = Res_MAKEINTERNAL(5),
    ATTR_ONE = Res_MAKEINTERNAL(6),
    ATTR_TWO = Res_MAKEINTERNAL(7),
    ATTR_FEW = Res_MAKEINTERNAL(8),
    ATTR_MANY = Res_MAKEINTERNAL(9)
};

// Bit mask of allowed types, for use with ATTR_TYPE.
enum {
    // No type has been defined for this attribute, use generic
    // type handling.  The low 16 bits are for types that can be
    // handled generically; the upper 16 require additional information
    // in the bag so can not be handled generically for TYPE_ANY.
    ATTR_TYPE_ANY = 0x0000FFFF,

    // Attribute holds a references to another resource.
    ATTR_TYPE_REFERENCE = 1<<0,

    // Attribute holds a generic string.
    ATTR_TYPE_STRING = 1<<1,

    // Attribute holds an integer value.  ATTR_MIN and ATTR_MIN can
    // optionally specify a constrained range of possible integer values.
    ATTR_TYPE_INTEGER = 1<<2,

    // Attribute holds a boolean integer.
    ATTR_TYPE_BOOLEAN = 1<<3,

    // Attribute holds a color value.
    ATTR_TYPE_COLOR = 1<<4,

    // Attribute holds a floating point value.
    ATTR_TYPE_FLOAT = 1<<5,

    // Attribute holds a dimension value, such as "20px".
    ATTR_TYPE_DIMENSION = 1<<6,

    // Attribute holds a fraction value, such as "20%".
    ATTR_TYPE_FRACTION = 1<<7,

    // Attribute holds an enumeration.  The enumeration values are
    // supplied as additional entries in the map.
    ATTR_TYPE_ENUM = 1<<16,

    // Attribute holds a bitmaks of flags.  The flag bit values are
    // supplied as additional entries in the map.
    ATTR_TYPE_FLAGS = 1<<17
};

// Enum of localization modes, for use with ATTR_L10N.
enum {
    L10N_NOT_REQUIRED = 0,
    L10N_SUGGESTED    = 1
};

/**
 * A single name/value mapping that is part of a complex resource
 * entry.
 */
struct ResTable_map
{
    // The resource identifier defining this mapping's name.  For attribute
    // resources, 'name' can be one of the following special resource types
    // to supply meta-data about the attribute; for all other resource types
    // it must be an attribute resource.
    struct ResTable_ref name;

    // This mapping's value.
    struct Res_value value;
};

struct bag_entry {
    ssize_t stringBlock;
    struct ResTable_map map;
};

enum {
    SCREENWIDTH_ANY = 0
};

enum {
    SCREENHEIGHT_ANY = 0
};

enum {
    SDKVERSION_ANY = 0
};

enum {
    MINORVERSION_ANY = 0
};

/**
 * Describes a particular resource configuration.
 */
struct ResTable_config
{
    // Number of bytes in this structure.
    uint32_t size;

    union {
        struct {
            // Mobile country code (from SIM).  0 means "any".
            uint16_t mcc;
            // Mobile network code (from SIM).  0 means "any".
            uint16_t mnc;
        };
        uint32_t imsi;
    };

    union {
        struct {
            // This field can take three different forms:
            // - \0\0 means "any".
            //
            // - Two 7 bit ascii values interpreted as ISO-639-1 language
            //   codes ('fr', 'en' etc. etc.). The high bit for both bytes is
            //   zero.
            //
            // - A single 16 bit little endian packed value representing an
            //   ISO-639-2 3 letter language code. This will be of the form:
            //
            //   {1, t, t, t, t, t, s, s, s, s, s, f, f, f, f, f}
            //
            //   bit[0, 4] = first letter of the language code
            //   bit[5, 9] = second letter of the language code
            //   bit[10, 14] = third letter of the language code.
            //   bit[15] = 1 always
            //
            // For backwards compatibility, languages that have unambiguous
            // two letter codes are represented in that format.
            //
            // The layout is always bigendian irrespective of the runtime
            // architecture.
            char language[2];

            // This field can take three different forms:
            // - \0\0 means "any".
            //
            // - Two 7 bit ascii values interpreted as 2 letter region
            //   codes ('US', 'GB' etc.). The high bit for both bytes is zero.
            //
            // - An UN M.49 3 digit region code. For simplicity, these are packed
            //   in the same manner as the language codes, though we should need
            //   only 10 bits to represent them, instead of the 15.
            //
            // The layout is always bigendian irrespective of the runtime
            // architecture.
            char country[2];
        };
        uint32_t locale;
    };

    union {
        struct {
            uint8_t orientation;
            uint8_t touchscreen;
            uint16_t density;
        };
        uint32_t screenType;
    };

    union {
        struct {
            uint8_t keyboard;
            uint8_t navigation;
            uint8_t inputFlags;
            uint8_t inputPad0;
        };
        uint32_t input;
    };

    union {
        struct {
            uint16_t screenWidth;
            uint16_t screenHeight;
        };
        uint32_t screenSize;
    };

    union {
        struct {
            uint16_t sdkVersion;
            // For now minorVersion must always be 0!!!  Its meaning
            // is currently undefined.
            uint16_t minorVersion;
        };
        uint32_t version;
    };

    union {
        struct {
            uint8_t screenLayout;
            uint8_t uiMode;
            uint16_t smallestScreenWidthDp;
        };
        uint32_t screenConfig;
    };

    union {
        struct {
            uint16_t screenWidthDp;
            uint16_t screenHeightDp;
        };
        uint32_t screenSizeDp;
    };

    // The ISO-15924 short name for the script corresponding to this
    // configuration. (eg. Hant, Latn, etc.). Interpreted in conjunction with
    // the locale field.
    char localeScript[4];

    // A single BCP-47 variant subtag. Will vary in length between 4 and 8
    // chars. Interpreted in conjunction with the locale field.
    char localeVariant[8];

    // An extension of screenConfig.
    union {
        struct {
            uint8_t screenLayout2;      // Contains round/notround qualifier.
            uint8_t colorMode;          // Wide-gamut, HDR, etc.
            uint16_t screenConfigPad2;  // Reserved padding.
        };
        uint32_t screenConfig2;
    };

    // If false and localeScript is set, it means that the script of the locale
    // was explicitly provided.
    //
    // If true, it means that localeScript was automatically computed.
    // localeScript may still not be set in this case, which means that we
    // tried but could not compute a script.
    bool localeScriptWasComputed;

    // The value of BCP 47 Unicode extension for key 'nu' (numbering system).
    // Varies in length from 3 to 8 chars. Zero-filled value.
    char localeNumberingSystem[8];

};

struct resource_name
{
    const char16_t* package;
    size_t packageLen;
    const char16_t* type;
    const char* type8;
    size_t typeLen;
    const char16_t* name;
    const char* name8;
    size_t nameLen;
};

enum AccessMode {
    ACCESS_UNKNOWN = 0,

    /* read chunks, and seek forward and backward */
    ACCESS_RANDOM,

    /* read sequentially, with an occasional forward seek */
    ACCESS_STREAMING,

    /* caller plans to ask for a read-only buffer with all data */
    ACCESS_BUFFER,
};

enum event_code_t {
    BAD_DOCUMENT = -1,
    START_DOCUMENT = 0,
    END_DOCUMENT = 1,

    FIRST_CHUNK_CODE = 0x0100, 

    START_NAMESPACE = 0x0100,
    END_NAMESPACE = 0x0101,
    START_TAG = 0x0102,
    END_TAG = 0x0103,
    TEXT = 0x0104,
};

struct AssetManager *AssetManager_new(void);
void AssetManager_setConfiguration(struct AssetManager *asset_manager, const struct ResTable_config *config, const char* locale);
bool AssetManager_addAssetPath(struct AssetManager *asset_manager, const char* path, int32_t* cookie, bool appAsLib, bool isSystemAsset);
const struct ResTable *AssetManager_getResources(struct AssetManager *asset_manager, bool required);

ssize_t ResTable_getResource(const struct ResTable *res_table, uint32_t resID, struct Res_value* outValue, bool mayBeBag,
                    uint16_t density,
                    uint32_t* outSpecFlags,
                    struct ResTable_config* outConfig);
ssize_t ResTable_resolveReference(const struct ResTable *res_table, struct Res_value* inOutValue,
     ssize_t blockIndex,
     uint32_t* outLastRef,
     uint32_t* inoutTypeSpecFlags,
     struct ResTable_config* outConfig);
/**
 * Retrieve the bag of a resource.  If the resoruce is found, returns the
 * number of bags it contains and 'outBag' points to an array of their
 * values.  If not found, a negative error code is returned.
 *
 * Note that this function -does- do reference traversal of the bag data.
 *
 * @param resID The desired resource identifier.
 * @param outBag Filled inm with a pointer to the bag mappings.
 *
 * @return ssize_t Either a >= 0 bag count of negative error code.
 */
ssize_t ResTable_lockBag(const struct ResTable *res_table, uint32_t resID, const struct bag_entry** outBag);
void ResTable_unlockBag(const struct ResTable *res_table, const struct bag_entry* bag);
// Retrieve an identifier (which can be passed to getResource)
// for a given resource name.  The 'name' can be fully qualified
// (<package>:<type>.<basename>) or the package or type components
// can be dropped if default values are supplied here.
//
// Returns 0 if no such resource was found, else a valid resource ID.
uint32_t ResTable_identifierForName(const struct ResTable *res_table, const char16_t* name, size_t nameLen,
                            const char16_t* type, size_t typeLen,
                            const char16_t* defPackage, size_t defPackageLen,
                            uint32_t* outTypeSpecFlags);
const struct ResStringPool* ResTable_getTableStringBlock(const struct ResTable *res_table, size_t index);
bool ResTable_getResourceName(const struct ResTable *res_table, uint32_t resID, bool allowUtf8, struct resource_name* outName);

const char16_t* ResStringPool_stringAt(const struct ResStringPool *res_string_pool, size_t idx, size_t *outLen);

struct Theme *Theme_new(const struct ResTable *res_table);
void Theme_delete(struct Theme *theme);
void Theme_applyStyle(struct Theme *theme, uint32_t style, bool force);
ssize_t Theme_getAttribute(const struct Theme *theme, uint32_t resID, struct Res_value *outValue, uint32_t *outTypeSpecFlags);
ssize_t Theme_resolveAttributeReference(const struct Theme *theme, struct Res_value *inOutValue,
     ssize_t blockIndex,
     uint32_t* outLastRef,
     uint32_t* inoutTypeSpecFlags,
     struct ResTable_config* outConfig);
void Theme_setTo(struct Theme *theme, const struct Theme *other);

struct Asset *AssetManager_openNonAsset(struct AssetManager *asset_manager, const char* filename, enum AccessMode mode);
const void *Asset_getBuffer(struct Asset *asset, bool wordAligned);
int Asset_openFileDescriptor(struct Asset *asset, off_t* outStart, off_t* outLength);
size_t Asset_getLength(struct Asset *asset);
void Asset_delete(struct Asset *asset);

struct ResXMLTree *ResXMLTree_new(void);
void ResXMLTree_setTo(struct ResXMLTree *tree, const void *data, size_t size, bool copyData); 
void ResXMLTree_delete(struct ResXMLTree *tree);

struct ResXMLParser *ResXMLParser_new(const struct ResXMLTree *tree);
void ResXMLParser_restart(struct ResXMLParser *parser);
enum event_code_t ResXMLParser_next(struct ResXMLParser *parser);
int ResXMLParser_getElementNameID(struct ResXMLParser *parser);
const struct ResStringPool *ResXMLParser_getStrings(struct ResXMLParser *parser);
size_t ResXMLParser_getAttributeCount(const struct ResXMLParser *parser);
uint32_t ResXMLParser_getAttributeNameResID(const struct ResXMLParser *parser, size_t idx);
ssize_t ResXMLParser_indexOfAttribute(const struct ResXMLParser *parser, const char16_t* ns, size_t nsLen, const char16_t* attr, size_t attrLen);
int32_t ResXMLParser_getAttributeValueStringID(const struct ResXMLParser *parser, size_t idx);
uint32_t ResXMLParser_getLineNumber(const struct ResXMLParser *parser);
int32_t ResXMLParser_getAttributeDataType(const struct ResXMLParser *parser, size_t idx);
int32_t ResXMLParser_getAttributeData(const struct ResXMLParser *parser, size_t idx);
ssize_t ResXMLParser_indexOfID(const struct ResXMLParser *parser);
ssize_t ResXMLParser_indexOfClass(const struct ResXMLParser *parser);
ssize_t ResXMLParser_indexOfStyle(const struct ResXMLParser *parser);
void ResXMLParser_getAttributeValue(const struct ResXMLParser *parser, size_t idx, struct Res_value *outValue);
void ResXMLParser_delete(struct ResXMLParser *parser);

#ifdef __cplusplus
}
#endif

#endif /* __ANDROIDFW_C_API_H */

