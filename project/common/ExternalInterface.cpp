#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include "Utils.h"

using namespace gamethrive;

// Configure
AutoGCRoot* notificationOpenedHandle = 0;

static void gamethrive_configure( value notificationOpenedHandler )
{
	notificationOpenedHandle = new AutoGCRoot(notificationOpenedHandler);
	
    gamethrive::Configure();
}
DEFINE_PRIM( gamethrive_configure, 1 )

// ShowAd
static void gamethrive_showDialog( value title, value message )
{
	const char* titleStr = val_get_string(title);
	const char* messageStr = val_get_string(message);
	
    gamethrive::ShowDialog( titleStr, messageStr );
}
DEFINE_PRIM( gamethrive_showDialog, 2 )

// Externs
extern "C" void gamethrive_main () {}
DEFINE_ENTRY_POINT (gamethrive_main);

extern "C" int gamethrive_register_prims () { return 0; }

// Events
extern "C" void notificationOpened( const char* message, const char* additionalData, bool isActive )
{
    val_call3( notificationOpenedHandle->get(), alloc_string(message), alloc_string(additionalData), alloc_bool(isActive) );
}