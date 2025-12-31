// Compile with:
// slangc -target host-object-code -emit-cpu-via-llvm hello_world.slang -o hello_world.o -llvm-target-triple thumb-v8-eabi -llvm-cpu cortex-m33 -llvm-features +dsp -Xllvm... -function-sections -data-sections -float-abi=soft -X. 
import pico;

export __extern_cpp int main()
{
    pico.stdio_init_all();
    if (pico.cyw43_arch_init() != 0)
    {
        printf("Failed to init Wi-Fi module\n");
        return -1;
    }

    for (;;)
    {
        printf("ON\n");
        pico.cyw43_arch_gpio_put(pico.CYW43_WL_GPIO_LED_PIN, true);
        pico.sleep_ms(500);
        printf("OFF\n");
        pico.cyw43_arch_gpio_put(pico.CYW43_WL_GPIO_LED_PIN, false);
        pico.sleep_ms(500);
    }
    return 0;
}
