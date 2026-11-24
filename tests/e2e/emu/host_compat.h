/* host_compat.h : inclus de force (/FI) pour compiler le code du firmware fw6 sur PC (MSVC, x86 32 bits). */
#pragma once
#define __attribute__(x)
#pragma warning(disable : 4244 4018 4146 4305 4267 4334 4554 4101 4189 4100 4057 4245 4133 4047 4024 4022 4716 4013)
