module st7789;

import pico;

using pico;

public struct ST7789
{
    enum Command : uint8_t
    {
        NOP = 0x00,
        SWRESET = 0x01,
        RDDID = 0x04,
        RDDST = 0x09,
        RDDPM = 0x0A,
        RDDMADCTL = 0x0B,
        RDDCOLMOD = 0x0C,
        RDDIM = 0x0D,
        RDDSM = 0x0E,
        RDDSDR = 0x0F,
        SLPIN = 0x10,
        SLPOUT = 0x11,
        PTLON = 0x12,
        NORON = 0x13,
        INVOFF = 0x20,
        INVON = 0x21,
        GAMSET = 0x26,
        DISPOFF = 0x28,
        DISPON = 0x29,
        CASET = 0x2A,
        RASET = 0x2B,
        RAMWR = 0x2C,
        RAMRD = 0x2E,
        PTLAR = 0x30,
        VSCRDEF = 0x33,
        TEOFF = 0x34,
        TEON = 0x35,
        MADCTL = 0x36,
        VSCRSADD = 0x37,
        IDMOFF = 0x38,
        IDMON = 0x39,
        COLMOD = 0x3A,
        RAMWRC = 0x3C,
        RAMRDC = 0x3E,
        TESCAN = 0x44,
        RDTESCAN = 0x45,
        WRDISBV = 0x51,
        RDDISBV = 0x52,
        WRCTRLD = 0x53,
        RDCTRLD = 0x54,
        WRCACE = 0x55,
        RDCABC = 0x56,
        WRCABCMB = 0x5E,
        RDCABCMB = 0x5F,
        RDABCSDR = 0x68,
        RDID1 = 0xDA,
        RDID2 = 0xDB,
        RDID3 = 0xDC,
        RAMCTRL = 0xB0,
        RGBCTRL = 0xB1,
        PORCTRL = 0xB2,
        FRCTRL1 = 0xB3,
        PARCTRL = 0xB5,
        GCTRL = 0xB7,
        GTADJ = 0xB8,
        DGMEN = 0xBA,
        VCOMS = 0xBB,
        LCMCTRL = 0xC0,
        IDSET = 0xC1,
        VDVVRHEN = 0xC2,
        VRHS = 0xC3,
        VDVSET = 0xC4,
        VCMOFSET = 0xC5,
        FRCTR2 = 0xC6,
        CABCCTRL = 0xC7,
        REGSEL1 = 0xC8,
        REGSEL2 = 0xCA,
        PWMFRSEL = 0xCC,
        PWCTRL1 = 0xD0,
        VAPVANEN = 0xD2,
        CMD2EN = 0xDF,
        PVGAMCTRL = 0xE0,
        NVGAMCTRL = 0xE1,
        DGMLUTR = 0xE2,
        DGMLUTB = 0xE3,
        GATECTRL = 0xE4,
        SPI2EN = 0xE7,
        PWCTRL2 = 0xE8,
        EQCTRL = 0xE9,
        PROMCTRL = 0xEC,
        PROMEN = 0xFA,
        NVMSET = 0xFC,
        PROMACT = 0xFE
    }

    spi_inst_t* spi;
    int width;
    int height;
    int txPin;
    int sckPin;
    int csPin;
    int dcPin;
    int rstPin;
    bool dataMode;

    public __init(
        spi_inst_t* spi,
        int width,
        int height,
        int txPin,
        int sckPin,
        int csPin,
        int dcPin,
        int rstPin
    ){
        this.spi = spi;
        this.width = width;
        this.height = height;
        this.txPin = txPin;
        this.sckPin = sckPin;
        this.csPin = csPin;
        this.dcPin = dcPin;
        this.rstPin = rstPin;
        this.dataMode = false;
    }

    [mutating]
    public void init()
    {
        spi_init(spi, 125 * 1000 * 1000);
        dataMode = true;

        gpio_set_function(txPin, GPIO_FUNC_SPI);
        gpio_set_function(sckPin, GPIO_FUNC_SPI);
        gpio_init(csPin);
        gpio_init(dcPin);
        gpio_init(rstPin);
        gpio_set_dir(csPin, true);
        gpio_set_dir(dcPin, true);
        gpio_set_dir(rstPin, true);
        gpio_put(csPin, 1);
        gpio_put(dcPin, 1);
        gpio_put(rstPin, 1);

        sleep_ms(100);

        sendCommand(Command.SWRESET);

        sleep_ms(150);

        sendCommand(Command.SLPOUT);

        sleep_ms(50);

        sendCommand(Command.COLMOD, 0x55);

        sleep_ms(10);

        sendCommand(Command.MADCTL, 0x00);

        sendCommand(Command.CASET, 0x00, 0x00, width>>8, width&0xFF);
        sendCommand(Command.RASET, 0x00, 0x00, height>>8, height&0xFF);

        invertColors(true);
        sendCommand(Command.NORON);
        sleep_ms(10);
        sendCommand(Command.DISPON);
        sleep_ms(10);
    }

    [mutating]
    private void sendCommand<each T>(Command cmd, expand each T args)
    {
        if (dataMode)
        {
            spi_set_format(spi, 8, SPI_CPOL_0, SPI_CPHA_0, SPI_MSB_FIRST);
            dataMode = false;
        }
        gpio_put(csPin, 0);
        gpio_put(dcPin, 0);
        spi_write_blocking(spi, Ptr<uint8_t>(&cmd), 1);

        if (countof(args) != 0)
        {
            uint8_t data[countof(args)];
            int index = 0;
            expand data[index++] = uint8_t(reinterpret<int>(each args));
            gpio_put(dcPin, 1);
            spi_write_blocking(spi, Ptr<uint8_t>(&data), countof(args));
        }
        else gpio_put(dcPin, 1);

        gpio_put(csPin, 1);
    }

    [mutating]
    private void ensureDataMode()
    {
        if (!dataMode)
        {
            gpio_put(csPin, 0);
            gpio_put(dcPin, 0);
            uint8_t cmd = uint8_t(Command.RAMWR);
            spi_write_blocking(spi, &cmd, 1);
            gpio_put(dcPin, 1);
            spi_set_format(spi, 16, SPI_CPOL_0, SPI_CPHA_0, SPI_MSB_FIRST);
            dataMode = true;
        }
    }

    [mutating]
    private void sendData(uint16_t* data, int len)
    {
        ensureDataMode();
        spi_write16_blocking(spi, data, len);
    }

    [mutating]
    public void invertColors(bool invert)
    {
        sendCommand(invert ? Command.INVON : Command.INVOFF);
        sleep_ms(10);
    }

    [mutating]
    public void writeTile(int x, int y, int w, int h, uint16_t* pixelData)
    {
        sendCommand(Command.CASET, x>>8, x&0xFF, (x+w-1)>>8, (x+w-1)&0xFF);
        sendCommand(Command.RASET, y>>8, y&0xFF, (y+h-1)>>8, (y+h-1)&0xFF);
        sendData(pixelData, w * h);
    }

    [mutating]
    public void writePixel(int x, int y, uint16_t pixelData)
    {
        writeTile(x, y, 1, 1, &pixelData);
    }

    [mutating]
    public void clear(uint16_t pixelData)
    {
        sendCommand(Command.CASET, 0x00, 0x00, width>>8, width&0xFF);
        sendCommand(Command.RASET, 0x00, 0x00, height>>8, height&0xFF);
        ensureDataMode();
        for (int i = 0; i < width*height; ++i)
            spi_write16_blocking(spi, &pixelData, 1);
    }
}
