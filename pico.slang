// Auto-generated bindings by slang-bindgen.py, from headers:
//   /home/julius/Ohjelmat/pico-sdk/src/rp2_common/pico_stdio/include/pico/stdio.h
//   /home/julius/Ohjelmat/pico-sdk/src/common/pico_time/include/pico/time.h
//   /home/julius/Ohjelmat/pico-sdk/src/host/hardware_gpio/include/hardware/gpio.h
//   /home/julius/Ohjelmat/pico-sdk/src/boards/include/boards/pico2_w.h
//   /home/julius/Ohjelmat/pico-sdk/src/rp2_common/pico_cyw43_arch/include/pico/cyw43_arch.h
namespace pico {
    public static let PICO_RP2350A = 1;
    public static let PICO_DEFAULT_UART = 0;
    public static let PICO_DEFAULT_UART_TX_PIN = 0;
    public static let PICO_DEFAULT_UART_RX_PIN = 1;
    public static let PICO_DEFAULT_I2C = 0;
    public static let PICO_DEFAULT_I2C_SDA_PIN = 4;
    public static let PICO_DEFAULT_I2C_SCL_PIN = 5;
    public static let PICO_DEFAULT_SPI = 0;
    public static let PICO_DEFAULT_SPI_SCK_PIN = 18;
    public static let PICO_DEFAULT_SPI_TX_PIN = 19;
    public static let PICO_DEFAULT_SPI_RX_PIN = 16;
    public static let PICO_DEFAULT_SPI_CSN_PIN = 17;
    public static let PICO_BOOT_STAGE2_CHOOSE_W25Q080 = 1;
    public static let PICO_FLASH_SPI_CLKDIV = 2;
    public static let PICO_FLASH_SIZE_BYTES = ( 4 * 1024 * 1024 );
    public static let CYW43_WL_GPIO_COUNT = 3;
    public static let CYW43_WL_GPIO_LED_PIN = 0;
    public static let CYW43_WL_GPIO_SMPS_PIN = 1;
    public static let CYW43_WL_GPIO_VBUS_PIN = 2;
    public static let CYW43_USES_VSYS_PIN = 1;
    public static let PICO_VSYS_PIN = 29;
    public static let PICO_RP2350_A2_SUPPORTED = 1;
    public static let CYW43_PIN_WL_DYNAMIC = 0;
    public static let CYW43_DEFAULT_PIN_WL_REG_ON = 23u;
    public static let CYW43_DEFAULT_PIN_WL_DATA_OUT = 24u;
    public static let CYW43_DEFAULT_PIN_WL_DATA_IN = 24u;
    public static let CYW43_DEFAULT_PIN_WL_HOST_WAKE = 24u;
    public static let CYW43_DEFAULT_PIN_WL_CLOCK = 29u;
    public static let CYW43_DEFAULT_PIN_WL_CS = 25u;
    public static let PICO_STDOUT_MUTEX = 1;
    public static let PICO_STDIO_ENABLE_CRLF_SUPPORT = 1;
    public static let PICO_STDIO_DEFAULT_CRLF = 1;
    public static let PICO_STDIO_STACK_BUFFER_SIZE = 128;
    public static let PICO_STDIO_DEADLOCK_TIMEOUT_MS = 1000;
    public static let PICO_STDIO_SHORT_CIRCUIT_CLIB_FUNCS = 1;
    public typealias stdio_driver_t = stdio_driver;
    public __extern_cpp bool stdio_init_all();
    public __extern_cpp bool stdio_deinit_all();
    public __extern_cpp void stdio_flush();
    public __extern_cpp int stdio_getchar_timeout_us(uint timeout_us);
    public __extern_cpp int getchar_timeout_us(uint timeout_us);
    public __extern_cpp void stdio_set_driver_enabled(Ptr<stdio_driver_t> driver, bool enabled);
    public __extern_cpp void stdio_filter_driver(Ptr<stdio_driver_t> driver);
    public __extern_cpp void stdio_set_translate_crlf(Ptr<stdio_driver_t> driver, bool translate);
    public __extern_cpp int stdio_putchar_raw(int c);
    public __extern_cpp int putchar_raw(int c);
    public __extern_cpp int stdio_puts_raw(Ptr<uint8_t> s);
    public __extern_cpp int puts_raw(Ptr<uint8_t> s);
    public __extern_cpp void stdio_set_chars_available_callback(Ptr<void> fn, Ptr<void> param);
    public __extern_cpp int stdio_get_until(Ptr<uint8_t> buf, int len, uint64_t until);
    public __extern_cpp int stdio_put_string(Ptr<uint8_t> s, int len, bool newline, bool cr_translation);
    public __extern_cpp int stdio_getchar();
    public __extern_cpp int stdio_putchar(int );
    public __extern_cpp int stdio_puts(Ptr<uint8_t> s);
    public static let PARAM_ASSERTIONS_ENABLED_PICO_TIME = 0;
    public static let PICO_TIME_SLEEP_OVERHEAD_ADJUST_US = 6;
    public __extern_cpp uint64_t get_absolute_time();
    public __extern_cpp uint us_to_ms(uint64_t us);
    public __extern_cpp uint to_ms_since_boot(uint64_t t);
    public __extern_cpp uint64_t delayed_by_us(const uint64_t t, uint64_t us);
    public __extern_cpp uint64_t delayed_by_ms(const uint64_t t, uint ms);
    public __extern_cpp uint64_t make_timeout_time_us(uint64_t us);
    public __extern_cpp uint64_t make_timeout_time_ms(uint ms);
    public __extern_cpp int64_t absolute_time_diff_us(uint64_t from, uint64_t to);
    public __extern_cpp uint64_t absolute_time_min(uint64_t a, uint64_t b);
    public __extern_cpp bool is_at_the_end_of_time(uint64_t t);
    public __extern_cpp bool is_nil_time(uint64_t t);
    public __extern_cpp void sleep_until(uint64_t target);
    public __extern_cpp void sleep_us(uint64_t us);
    public __extern_cpp void sleep_ms(uint ms);
    public static let PICO_TIME_DEFAULT_ALARM_POOL_DISABLED = 0;
    public static let PICO_TIME_DEFAULT_ALARM_POOL_HARDWARE_ALARM_NUM = 3;
    public static let PICO_TIME_DEFAULT_ALARM_POOL_MAX_TIMERS = 16;
    public __extern_cpp bool best_effort_wfe_or_timeout(uint64_t timeout_timestamp);
    public typealias alarm_id_t = int;
    public typealias alarm_callback_t = Ptr<void>;
    public typealias alarm_pool_t = alarm_pool;
    public typealias alarm_pool_timer_t = void;
    public __extern_cpp void alarm_pool_init_default();
    public __extern_cpp void runtime_init_default_alarm_pool();
    public __extern_cpp Ptr<alarm_pool_t> alarm_pool_get_default();
    public __extern_cpp Ptr<alarm_pool_t> alarm_pool_create_on_timer(Ptr<alarm_pool_timer_t> timer, uint timer_alarm_num, uint max_timers);
    public __extern_cpp Ptr<alarm_pool_timer_t> alarm_pool_timer_for_timer_num(uint timer_num);
    public __extern_cpp Ptr<alarm_pool_timer_t> alarm_pool_get_default_timer();
    public __extern_cpp Ptr<alarm_pool_t> alarm_pool_create(uint timer_alarm_num, uint max_timers);
    public __extern_cpp Ptr<alarm_pool_t> alarm_pool_create_on_timer_with_unused_hardware_alarm(Ptr<alarm_pool_timer_t> timer, uint max_timers);
    public __extern_cpp Ptr<alarm_pool_t> alarm_pool_create_with_unused_hardware_alarm(uint max_timers);
    public __extern_cpp uint alarm_pool_timer_alarm_num(Ptr<alarm_pool_t> pool);
    public __extern_cpp uint alarm_pool_hardware_alarm_num(Ptr<alarm_pool_t> pool);
    public __extern_cpp uint alarm_pool_core_num(Ptr<alarm_pool_t> pool);
    public __extern_cpp void alarm_pool_destroy(Ptr<alarm_pool_t> pool);
    public __extern_cpp alarm_id_t alarm_pool_add_alarm_at(Ptr<alarm_pool_t> pool, uint64_t time, alarm_callback_t callback, Ptr<void> user_data, bool fire_if_past);
    public __extern_cpp alarm_id_t alarm_pool_add_alarm_at_force_in_context(Ptr<alarm_pool_t> pool, uint64_t time, alarm_callback_t callback, Ptr<void> user_data);
    public __extern_cpp alarm_id_t alarm_pool_add_alarm_in_us(Ptr<alarm_pool_t> pool, uint64_t us, alarm_callback_t callback, Ptr<void> user_data, bool fire_if_past);
    public __extern_cpp alarm_id_t alarm_pool_add_alarm_in_ms(Ptr<alarm_pool_t> pool, uint ms, alarm_callback_t callback, Ptr<void> user_data, bool fire_if_past);
    public __extern_cpp int64_t alarm_pool_remaining_alarm_time_us(Ptr<alarm_pool_t> pool, alarm_id_t alarm_id);
    public __extern_cpp int alarm_pool_remaining_alarm_time_ms(Ptr<alarm_pool_t> pool, alarm_id_t alarm_id);
    public __extern_cpp bool alarm_pool_cancel_alarm(Ptr<alarm_pool_t> pool, alarm_id_t alarm_id);
    public __extern_cpp alarm_id_t add_alarm_at(uint64_t time, alarm_callback_t callback, Ptr<void> user_data, bool fire_if_past);
    public __extern_cpp alarm_id_t add_alarm_in_us(uint64_t us, alarm_callback_t callback, Ptr<void> user_data, bool fire_if_past);
    public __extern_cpp alarm_id_t add_alarm_in_ms(uint ms, alarm_callback_t callback, Ptr<void> user_data, bool fire_if_past);
    public __extern_cpp bool cancel_alarm(alarm_id_t alarm_id);
    public __extern_cpp int64_t remaining_alarm_time_us(alarm_id_t alarm_id);
    public __extern_cpp int remaining_alarm_time_ms(alarm_id_t alarm_id);
    public typealias repeating_timer_t = repeating_timer;
    public typealias repeating_timer_callback_t = Ptr<void>;
    public struct repeating_timer {
        public int64_t delay_us;
        public Ptr<alarm_pool_t> pool;
        public alarm_id_t alarm_id;
        public repeating_timer_callback_t callback;
        public Ptr<void> user_data;
    };
    public __extern_cpp bool alarm_pool_add_repeating_timer_us(Ptr<alarm_pool_t> pool, int64_t delay_us, repeating_timer_callback_t callback, Ptr<void> user_data, Ptr<repeating_timer_t> out);
    public __extern_cpp bool alarm_pool_add_repeating_timer_ms(Ptr<alarm_pool_t> pool, int delay_ms, repeating_timer_callback_t callback, Ptr<void> user_data, Ptr<repeating_timer_t> out);
    public __extern_cpp bool add_repeating_timer_us(int64_t delay_us, repeating_timer_callback_t callback, Ptr<void> user_data, Ptr<repeating_timer_t> out);
    public __extern_cpp bool add_repeating_timer_ms(int delay_ms, repeating_timer_callback_t callback, Ptr<void> user_data, Ptr<repeating_timer_t> out);
    public __extern_cpp bool cancel_repeating_timer(Ptr<repeating_timer_t> timer);
    public enum gpio_function: uint {
        GPIO_FUNC_XIP = 0,
        GPIO_FUNC_SPI = 1,
        GPIO_FUNC_UART = 2,
        GPIO_FUNC_I2C = 3,
        GPIO_FUNC_PWM = 4,
        GPIO_FUNC_SIO = 5,
        GPIO_FUNC_PIO0 = 6,
        GPIO_FUNC_PIO1 = 7,
        GPIO_FUNC_GPCK = 8,
        GPIO_FUNC_USB = 9,
        GPIO_FUNC_NULL = 15,
    };
    public enum gpio_slew_rate: uint {
        GPIO_SLEW_RATE_SLOW = 0,
        GPIO_SLEW_RATE_FAST = 1,
    };
    public static let GPIO_OUT = 1;
    public static let GPIO_IN = 0;
    public enum gpio_drive_strength: uint {
        GPIO_DRIVE_STRENGTH_2MA = 0,
        GPIO_DRIVE_STRENGTH_4MA = 1,
        GPIO_DRIVE_STRENGTH_8MA = 2,
        GPIO_DRIVE_STRENGTH_12MA = 3,
    };
    public __extern_cpp void gpio_set_function(uint gpio, gpio_function fn);
    public __extern_cpp gpio_function gpio_get_function(uint gpio);
    public __extern_cpp void gpio_pull_up(uint gpio);
    public __extern_cpp void gpio_pull_down(uint gpio);
    public __extern_cpp void gpio_disable_pulls(uint gpio);
    public __extern_cpp void gpio_set_pulls(uint gpio, bool up, bool down);
    public __extern_cpp void gpio_set_irqover(uint gpio, uint value);
    public __extern_cpp void gpio_set_outover(uint gpio, uint value);
    public __extern_cpp void gpio_set_inover(uint gpio, uint value);
    public __extern_cpp void gpio_set_oeover(uint gpio, uint value);
    public __extern_cpp void gpio_set_input_enabled(uint gpio, bool enable);
    public __extern_cpp void gpio_set_input_hysteresis_enabled(uint gpio, bool enabled);
    public __extern_cpp bool gpio_is_input_hysteresis_enabled(uint gpio);
    public __extern_cpp void gpio_set_slew_rate(uint gpio, gpio_slew_rate slew);
    public __extern_cpp gpio_slew_rate gpio_get_slew_rate(uint gpio);
    public __extern_cpp void gpio_set_drive_strength(uint gpio, gpio_drive_strength drive);
    public __extern_cpp gpio_drive_strength gpio_get_drive_strength(uint gpio);
    public __extern_cpp void gpio_init(uint gpio);
    public __extern_cpp void gpio_init_mask(uint gpio_mask);
    public __extern_cpp bool gpio_get(uint gpio);
    public __extern_cpp uint gpio_get_all();
    public __extern_cpp void gpio_set_mask(uint mask);
    public __extern_cpp void gpio_clr_mask(uint mask);
    public __extern_cpp void gpio_xor_mask(uint mask);
    public __extern_cpp void gpio_put_masked(uint mask, uint value);
    public __extern_cpp void gpio_put_all(uint value);
    public __extern_cpp void gpio_put(uint gpio, int value);
    public __extern_cpp void gpio_set_dir_out_masked(uint mask);
    public __extern_cpp void gpio_set_dir_in_masked(uint mask);
    public __extern_cpp void gpio_set_dir_masked(uint mask, uint value);
    public __extern_cpp void gpio_set_dir_all_bits(uint value);
    public static let PICO_DEBUG_PIN_BASE = 19u;
    public __extern_cpp void gpio_set_dir(uint gpio, bool out);
    public __extern_cpp void gpio_debug_pins_init();
    public static let PARAM_ASSERTIONS_ENABLED_PICO_CYW43_ARCH = 0;
    public static let PICO_CYW43_ARCH_DEBUG_ENABLED = 0;
    public __extern_cpp int cyw43_arch_init();
    public __extern_cpp int cyw43_arch_init_with_country(uint country);
    public __extern_cpp void cyw43_arch_deinit();
    public __extern_cpp Ptr<async_context> cyw43_arch_async_context();
    public __extern_cpp void cyw43_arch_set_async_context(Ptr<async_context> context);
    public __extern_cpp Ptr<async_context> cyw43_arch_init_default_async_context();
    public __extern_cpp void cyw43_arch_poll();
    public __extern_cpp void cyw43_arch_wait_for_work_until(uint64_t until);
    public __extern_cpp void cyw43_arch_lwip_begin();
    public __extern_cpp void cyw43_arch_lwip_end();
    public __extern_cpp int cyw43_arch_lwip_protect(Ptr<void> func, Ptr<void> param);
    public __extern_cpp uint cyw43_arch_get_country_code();
    public __extern_cpp void cyw43_arch_enable_sta_mode();
    public __extern_cpp void cyw43_arch_disable_sta_mode();
    public __extern_cpp void cyw43_arch_enable_ap_mode(Ptr<uint8_t> ssid, Ptr<uint8_t> password, uint auth);
    public __extern_cpp void cyw43_arch_disable_ap_mode();
    public __extern_cpp int cyw43_arch_wifi_connect_blocking(Ptr<uint8_t> ssid, Ptr<uint8_t> pw, uint auth);
    public __extern_cpp int cyw43_arch_wifi_connect_bssid_blocking(Ptr<uint8_t> ssid, Ptr<uint8_t> bssid, Ptr<uint8_t> pw, uint auth);
    public __extern_cpp int cyw43_arch_wifi_connect_timeout_ms(Ptr<uint8_t> ssid, Ptr<uint8_t> pw, uint auth, uint timeout);
    public __extern_cpp int cyw43_arch_wifi_connect_bssid_timeout_ms(Ptr<uint8_t> ssid, Ptr<uint8_t> bssid, Ptr<uint8_t> pw, uint auth, uint timeout);
    public __extern_cpp int cyw43_arch_wifi_connect_async(Ptr<uint8_t> ssid, Ptr<uint8_t> pw, uint auth);
    public __extern_cpp int cyw43_arch_wifi_connect_bssid_async(Ptr<uint8_t> ssid, Ptr<uint8_t> bssid, Ptr<uint8_t> pw, uint auth);
    public __extern_cpp void cyw43_arch_gpio_put(uint wl_gpio, bool value);
    public __extern_cpp bool cyw43_arch_gpio_get(uint wl_gpio);
    public struct __va_list;
    public struct alarm_pool;
    public struct async_context;
    public struct stdio_driver;
}
