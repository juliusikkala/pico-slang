import pico;

export __extern_cpp int main()
{
    pico.stdio_init_all();
    if (pico.cyw43_arch_init() != 0)
    {
        printf("Failed to init Wi-Fi module\n");
        return -1;
    }

    float4 v = float4(1.0, 2.0, 3.0, 4.0);

    for (;;)
    {
        printf("%f, %f, %f, %f\n", v.x, v.y, v.z, v.w);
        printf("ON\n");
        pico.cyw43_arch_gpio_put(pico.CYW43_WL_GPIO_LED_PIN, true);
        pico.sleep_ms(750);
        printf("OFF\n");
        pico.cyw43_arch_gpio_put(pico.CYW43_WL_GPIO_LED_PIN, false);
        pico.sleep_ms(250);
        v = cos(v);
    }
    return 0;
}
