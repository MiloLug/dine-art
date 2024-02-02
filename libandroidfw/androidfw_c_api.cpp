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
