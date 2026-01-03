// I'm so, so sorry... But I really need the inline functions in an object file
// for the Slang bindings to work.
#define static extern
#include <hardware/spi.h>
#include <hardware/gpio.h>
#include <pico/time.h>
#include <pico/multicore.h>
#include <pico/mutex.h>
