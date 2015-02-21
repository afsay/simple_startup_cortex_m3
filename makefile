RM := rm -rf

# Every subdirectory with source files must be described here
SUBDIRS := \
src \

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
src/startup.c \
src/main.c 

OBJS += \
src/startup.o \
src/main.o 

# Each subdirectory must supply rules for building sources it contributes
src/%.o: src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU C Compiler'
	arm-none-eabi-gcc -DDEBUG  -D__USE_LPCOPEN -DCORE_M3 -D__NEWLIB__  -O0 -g3 -Wall -c -fmessage-length=0 -fno-builtin -ffunction-sections -fdata-sections -mcpu=cortex-m3 -mthumb -D__NEWLIB__ -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

# All Target
all: simple_startup.axf

# Tool invocations
simple_startup.axf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: GNU Linker'
	arm-none-eabi-gcc -nostdlib -L"/home/afs/newlib-2.2.0-1-build/arm-none-eabi/newlib" -Xlinker --gc-sections -mcpu=cortex-m3 -mthumb -T "simple_startup.ld" -o "simple_startup.axf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '
	$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES) simple_startup.axf
	-@echo ' '

post-build:
	-@echo 'Performing post-build steps'
	-arm-none-eabi-size "simple_startup.axf"; # arm-none-eabi-objcopy -v -O binary "simple_startup.axf" "simple_startup.bin" ; # checksum -p LPC1769 -d "simple_startup.bin";
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY: post-build

