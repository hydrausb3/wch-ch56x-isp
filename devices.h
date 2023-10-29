#define SZ_1K  (1024)
#define SZ_32K (32 * SZ_1K)
#define SZ_64K (64 * SZ_1K)
#define SZ_96K (64 * SZ_1K)
#define SZ_448K (448 * SZ_1K)

struct dev
{
	u8 type;
	u8 id;
	const char *name;
	u32 flash_size;
	u32 eeprom_size;
	u32 flash_sector_size;
};

struct dev devices[] =
{
	/* type    id  name           flash    eeprom */
	{ 0x10, 0x65, "CH565",        SZ_448K, SZ_32K, .flash_sector_size = 256 },
	{ 0x10, 0x69, "CH569",        SZ_448K, SZ_32K, .flash_sector_size = 256 },

};
