#include <androidfw/AssetManager.h>
#include <androidfw/ResourceTypes.h>
#include <androidfw/androidfw_c_api.h>
#include "include/androidfw/ResourceTypes.h"

extern "C" struct AssetManager *AssetManager_new(void)
{
  android::AssetManager *assetManager = new android::AssetManager();
  return reinterpret_cast<struct AssetManager *>(assetManager);
}

extern "C" void AssetManager_setConfiguration(struct AssetManager *asset_manager, const ResTable_config *config, const char* locale)
{
  android::AssetManager *assetManager = reinterpret_cast<android::AssetManager *>(asset_manager);
  assetManager->setConfiguration(*reinterpret_cast<const android::ResTable_config *>(config), locale);
}

extern "C" bool AssetManager_addAssetPath(struct AssetManager *asset_manager, const char* path, int32_t* cookie, bool appAsLib, bool isSystemAsset)
{
  android::AssetManager *assetManager = reinterpret_cast<android::AssetManager *>(asset_manager);
  return assetManager->addAssetPath(android::String8(path), cookie, appAsLib, isSystemAsset);
}

extern "C" const struct ResTable *AssetManager_getResources(struct AssetManager *asset_manager, bool required)
{
  android::AssetManager *assetManager = reinterpret_cast<android::AssetManager *>(asset_manager);
  const android::ResTable &resTable = assetManager->getResources(required);
  return reinterpret_cast<const struct ResTable *>(&resTable);
}

extern "C" ssize_t ResTable_getResource(const struct ResTable *res_table, uint32_t resID, struct Res_value* out_value, bool mayBeBag, uint16_t density, uint32_t* outSpecFlags, ResTable_config* out_config)
{
  const android::ResTable *resTable = reinterpret_cast<const android::ResTable *>(res_table);
  android::Res_value *outValue = reinterpret_cast<android::Res_value *>(out_value);
  android::ResTable_config *outConfig = reinterpret_cast<android::ResTable_config *>(out_config);
  return resTable->getResource(resID, outValue, mayBeBag, density, outSpecFlags, outConfig);
}

extern "C" ssize_t ResTable_resolveReference(const struct ResTable *res_table, struct Res_value* in_out_value, ssize_t blockIndex, uint32_t* outLastRef, uint32_t* inoutTypeSpecFlags, ResTable_config* out_config)
{
  const android::ResTable *resTable = reinterpret_cast<const android::ResTable *>(res_table);
  android::Res_value *inOutValue = reinterpret_cast<android::Res_value *>(in_out_value);
  android::ResTable_config *outConfig = reinterpret_cast<android::ResTable_config *>(out_config);
  return resTable->resolveReference(inOutValue, blockIndex, outLastRef, inoutTypeSpecFlags, outConfig);
}

extern "C" ssize_t ResTable_lockBag(const struct ResTable *res_table, uint32_t resID, const struct bag_entry** out_bag)
{
  const android::ResTable *resTable = reinterpret_cast<const android::ResTable *>(res_table);
  return resTable->lockBag(resID, reinterpret_cast<const android::ResTable::bag_entry **>(out_bag));
}

extern "C" void ResTable_unlockBag(const struct ResTable *res_table, const bag_entry* bag)
{
  const android::ResTable *resTable = reinterpret_cast<const android::ResTable *>(res_table);
  resTable->unlockBag(reinterpret_cast<const android::ResTable::bag_entry *>(bag));
}

extern "C" uint32_t ResTable_identifierForName(const struct ResTable *res_table, const char16_t* name, size_t nameLen,
            const char16_t* type, size_t typeLen, const char16_t* defPackage, size_t defPackageLen, uint32_t* outTypeSpecFlags)
{
  const android::ResTable *resTable = reinterpret_cast<const android::ResTable *>(res_table);
  return resTable->identifierForName(name, nameLen, type, typeLen, defPackage, defPackageLen, outTypeSpecFlags);
}

extern "C" const struct ResStringPool* ResTable_getTableStringBlock(const struct ResTable *res_table, size_t index)
{
  const android::ResTable *resTable = reinterpret_cast<const android::ResTable *>(res_table);
  const android::ResStringPool *stringPool = resTable->getTableStringBlock(index);
  return reinterpret_cast<const struct ResStringPool *>(stringPool);
}

extern "C" bool ResTable_getResourceName(const struct ResTable *res_table, uint32_t resID, bool allowUtf8, struct resource_name* outName)
{
  const android::ResTable *resTable = reinterpret_cast<const android::ResTable *>(res_table);
  return resTable->getResourceName(resID, allowUtf8, reinterpret_cast<android::ResTable::resource_name *>(outName));
}

extern "C" const char16_t* ResStringPool_stringAt(const struct ResStringPool *res_string_pool, size_t idx, size_t *outLen)
{
  const android::ResStringPool *stringPool = reinterpret_cast<const android::ResStringPool *>(res_string_pool);
  return stringPool->stringAt(idx, outLen);
}

extern "C" struct Theme *Theme_new(const struct ResTable *res_table)
{
  const android::ResTable *resTable = reinterpret_cast<const android::ResTable *>(res_table);
  android::ResTable::Theme *theme = new android::ResTable::Theme(*resTable);
  return reinterpret_cast<struct Theme *>(theme);
}

extern "C" void Theme_delete(struct Theme *theme)
{
  android::ResTable::Theme *themePtr = reinterpret_cast<android::ResTable::Theme *>(theme);
  delete themePtr;
}

extern "C" void Theme_applyStyle(struct Theme *theme, uint32_t style, bool force)
{
  android::ResTable::Theme *themePtr = reinterpret_cast<android::ResTable::Theme *>(theme);
  themePtr->applyStyle(style, force);
}

extern "C" ssize_t Theme_getAttribute(const struct Theme *theme, uint32_t resID, struct Res_value *out_value, uint32_t *outTypeSpecFlags)
{
  const android::ResTable::Theme *themePtr = reinterpret_cast<const android::ResTable::Theme *>(theme);
  android::Res_value *outValue = reinterpret_cast<android::Res_value *>(out_value);
  return themePtr->getAttribute(resID, outValue, outTypeSpecFlags);
}

extern "C" ssize_t Theme_resolveAttributeReference(const struct Theme *theme, struct Res_value *inOutValue, ssize_t blockIndex, uint32_t* outLastRef, uint32_t* inoutTypeSpecFlags, struct ResTable_config* out_config)
{
  const android::ResTable::Theme *themePtr = reinterpret_cast<const android::ResTable::Theme *>(theme);
  android::Res_value *inOutValuePtr = reinterpret_cast<android::Res_value *>(inOutValue);
  android::ResTable_config *outConfig = reinterpret_cast<android::ResTable_config *>(out_config);
  return themePtr->resolveAttributeReference(inOutValuePtr, blockIndex, outLastRef, inoutTypeSpecFlags, outConfig);
}

extern "C" void Theme_setTo(struct Theme *theme, const struct Theme *other)
{
  android::ResTable::Theme *themePtr = reinterpret_cast<android::ResTable::Theme *>(theme);
  themePtr->setTo(*reinterpret_cast<const android::ResTable::Theme *>(other));
}

extern "C" struct Asset *AssetManager_openNonAsset(struct AssetManager *asset_manager, const char* filename, enum AccessMode mode)
{
  android::AssetManager *assetManager = reinterpret_cast<android::AssetManager *>(asset_manager);
  android::Asset *asset = assetManager->openNonAsset(filename, (android::Asset::AccessMode)mode);
  return reinterpret_cast<struct Asset *>(asset);
}

extern "C" const void *Asset_getBuffer(struct Asset *asset, bool wordAligned)
{
  android::Asset *assetPtr = reinterpret_cast<android::Asset *>(asset);
  return assetPtr->getBuffer(wordAligned);
}

extern "C" int Asset_openFileDescriptor(struct Asset *asset, off64_t* outStart, off64_t* outLength)
{
  android::Asset *assetPtr = reinterpret_cast<android::Asset *>(asset);
  return assetPtr->openFileDescriptor(outStart, outLength);
}

extern "C" size_t Asset_getLength(struct Asset *asset)
{
  android::Asset *assetPtr = reinterpret_cast<android::Asset *>(asset);
  return assetPtr->getLength();
}

extern "C" void Asset_delete(struct Asset *asset)
{
  android::Asset *assetPtr = reinterpret_cast<android::Asset *>(asset);
  delete assetPtr;
}

extern "C" struct ResXMLTree *ResXMLTree_new(void)
{
  android::ResXMLTree *tree = new android::ResXMLTree();
  return reinterpret_cast<struct ResXMLTree *>(tree);
}

extern "C" void ResXMLTree_setTo(struct ResXMLTree *tree, const void *data, size_t size, bool copyData)
{
  android::ResXMLTree *treePtr = reinterpret_cast<android::ResXMLTree *>(tree);
  treePtr->setTo(data, size, copyData);
}

extern "C" void ResXMLTree_delete(struct ResXMLTree *tree)
{
  android::ResXMLTree *treePtr = reinterpret_cast<android::ResXMLTree *>(tree);
  delete treePtr;
}

extern "C" struct ResXMLParser *ResXMLParser_new(const struct ResXMLTree *tree)
{
  const android::ResXMLTree *treePtr = reinterpret_cast<const android::ResXMLTree *>(tree);
  android::ResXMLParser *parser = new android::ResXMLParser(*treePtr);
  return reinterpret_cast<struct ResXMLParser *>(parser);
}

extern "C" void ResXMLParser_restart(struct ResXMLParser *parser)
{
  android::ResXMLParser *parserPtr = reinterpret_cast<android::ResXMLParser *>(parser);
  parserPtr->restart();
}

extern "C" enum event_code_t ResXMLParser_next(struct ResXMLParser *parser)
{
  android::ResXMLParser *parserPtr = reinterpret_cast<android::ResXMLParser *>(parser);
  return (enum event_code_t)parserPtr->next();
}

extern "C" int ResXMLParser_getElementNameID(struct ResXMLParser *parser)
{
  android::ResXMLParser *parserPtr = reinterpret_cast<android::ResXMLParser *>(parser);
  return parserPtr->getElementNameID();
}

extern "C" const struct ResStringPool *ResXMLParser_getStrings(struct ResXMLParser *parser)
{
  android::ResXMLParser *parserPtr = reinterpret_cast<android::ResXMLParser *>(parser);
  const android::ResStringPool &pool = parserPtr->getStrings();
  return reinterpret_cast<const struct ResStringPool *>(&pool);
}

extern "C" size_t ResXMLParser_getAttributeCount(const struct ResXMLParser *parser)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->getAttributeCount();
}

extern "C" uint32_t ResXMLParser_getAttributeNameResID(const struct ResXMLParser *parser, size_t idx)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->getAttributeNameResID(idx);
}

extern "C" ssize_t ResXMLParser_indexOfAttribute(const struct ResXMLParser *parser, const char16_t* ns, size_t nsLen, const char16_t* attr, size_t attrLen)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->indexOfAttribute(ns, nsLen, attr, attrLen);
}

extern "C" int32_t ResXMLParser_getAttributeValueStringID(const struct ResXMLParser *parser, size_t idx)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->getAttributeValueStringID(idx);
}

extern "C" uint32_t ResXMLParser_getLineNumber(const struct ResXMLParser *parser)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->getLineNumber();
}

extern "C" int32_t ResXMLParser_getAttributeDataType(const struct ResXMLParser *parser, size_t idx)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->getAttributeDataType(idx);
}

extern "C" int32_t ResXMLParser_getAttributeData(const struct ResXMLParser *parser, size_t idx)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->getAttributeData(idx);
}

extern "C" void ResXMLParser_delete(struct ResXMLParser *parser)
{
  android::ResXMLParser *parserPtr = reinterpret_cast<android::ResXMLParser *>(parser);
  delete parserPtr;
}

extern"C" ssize_t ResXMLParser_indexOfID(const struct ResXMLParser *parser)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->indexOfID();
}

extern "C" ssize_t ResXMLParser_indexOfClass(const struct ResXMLParser *parser)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->indexOfClass();
}

extern "C" ssize_t ResXMLParser_indexOfStyle(const struct ResXMLParser *parser)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  return parserPtr->indexOfStyle();
}

extern "C" void ResXMLParser_getAttributeValue(const struct ResXMLParser *parser, size_t idx, struct Res_value *outValue)
{
  const android::ResXMLParser *parserPtr = reinterpret_cast<const android::ResXMLParser *>(parser);
  parserPtr->getAttributeValue(idx, reinterpret_cast<android::Res_value *>(outValue));
}
