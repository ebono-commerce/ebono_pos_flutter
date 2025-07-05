#ifndef FLUTTER_MY_APPLICATION_H_
#define FLUTTER_MY_APPLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(MyApplication, my_application, MY, APPLICATION,
                     GtkApplication)

/**
 * my_application_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #MyApplication.
 */
//MyApplication* my_application_new();

/**
 * my_application_new:
 *
 * Creates a new Flutter-based application with single instance enforcement.
 *
 * Features:
 * - Opens in fullscreen mode initially
 * - Regains fullscreen and shows on top only when activated from dock
 * - Allows other applications to show on top normally
 * - Maintains strictly one instance
 *
 * Returns: a new #MyApplication.
 */
MyApplication* my_application_new(void);

#endif  // FLUTTER_MY_APPLICATION_H_
