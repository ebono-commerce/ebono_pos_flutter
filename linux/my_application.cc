#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
    GtkApplication parent_instance;
    char** dart_entrypoint_arguments;
    GtkWindow* main_window;  // Track the window
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// GApplication::activate - app launched or clicked from dock
static void my_application_activate(GApplication* application) {
    MyApplication* self = MY_APPLICATION(application);

    // If window already exists, bring to front and fullscreen it again
    if (self->main_window != NULL) {
        gtk_window_present(self->main_window);
        gtk_window_fullscreen(self->main_window);  // Reapply fullscreen
        return;
    }

    GtkWindow* window = GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));
    self->main_window = window;

    gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
    GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif

    if (use_header_bar) {
        GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
        gtk_widget_show(GTK_WIDGET(header_bar));
        gtk_header_bar_set_title(header_bar, "ebono_pos");
        gtk_header_bar_set_show_close_button(header_bar, TRUE);
        gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
    } else {
        gtk_window_set_title(window, "ebono_pos");
    }

    gtk_window_set_default_size(window, 1280, 720);

    // Fullscreen on initial launch
    gtk_window_fullscreen(window);
    gtk_window_set_keep_above(window, TRUE);

    gtk_widget_show(GTK_WIDGET(window));

    // Create Flutter view
    g_autoptr(FlDartProject) project = fl_dart_project_new();
    fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

    FlView* view = fl_view_new(project);
    gtk_widget_show(GTK_WIDGET(view));
    gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

    // Register plugins
    fl_register_plugins(FL_PLUGIN_REGISTRY(view));
    gtk_widget_grab_focus(GTK_WIDGET(view));
}

// GApplication::local_command_line
static gboolean my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
    MyApplication* self = MY_APPLICATION(application);
    self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

    g_autoptr(GError) error = NULL;
    if (!g_application_register(application, NULL, &error)) {
        g_warning("Failed to register: %s", error->message);
        *exit_status = 1;
        return TRUE;
    }

    g_application_activate(application);
    *exit_status = 0;
    return TRUE;
}

// GApplication::startup
static void my_application_startup(GApplication* application) {
    G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// GApplication::shutdown
static void my_application_shutdown(GApplication* application) {
    G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// GObject::dispose
static void my_application_dispose(GObject* object) {
    MyApplication* self = MY_APPLICATION(object);
    g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);

    if (self->main_window != NULL) {
        gtk_widget_destroy(GTK_WIDGET(self->main_window));
        self->main_window = NULL;
    }

    G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

// Class init
static void my_application_class_init(MyApplicationClass* klass) {
    G_APPLICATION_CLASS(klass)->activate = my_application_activate;
    G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
    G_APPLICATION_CLASS(klass)->startup = my_application_startup;
    G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
    G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

// Instance init
static void my_application_init(MyApplication* self) {}

// Factory method
MyApplication* my_application_new() {
    return MY_APPLICATION(g_object_new(my_application_get_type(),
                                       "application-id", APPLICATION_ID,
                                       "flags", G_APPLICATION_NON_UNIQUE,
                                       NULL));
}
