#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
    GtkApplication parent_instance;
    char** dart_entrypoint_arguments;
    GtkWindow* main_window;
    gboolean is_fullscreen;
    gboolean activated_from_dock;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

static void force_fullscreen_and_top(MyApplication* self) {
    if (GTK_IS_WINDOW(self->main_window)) {
        // Set window to stay on top of all other windows
        gtk_window_set_keep_above(self->main_window, TRUE);

        // Force fullscreen mode
        gtk_window_fullscreen(self->main_window);
        self->is_fullscreen = TRUE;

        // Present window to bring it to front
        gtk_window_present(self->main_window);
    }
}

static void allow_other_apps_on_top(MyApplication* self) {
    if (GTK_IS_WINDOW(self->main_window)) {
        // Allow other applications to show on top
        gtk_window_set_keep_above(self->main_window, FALSE);
    }
}

static gboolean on_window_state_event(GtkWidget* widget, GdkEventWindowState* event, gpointer user_data) {
    MyApplication* self = (MyApplication*)user_data;

    // Track fullscreen state changes
    if (!(event->new_window_state & GDK_WINDOW_STATE_FULLSCREEN)) {
        self->is_fullscreen = FALSE;
        // When leaving fullscreen, allow other apps on top
        allow_other_apps_on_top(self);
    } else {
        self->is_fullscreen = TRUE;
    }

    return FALSE;
}

static void on_secondary_activation(GApplication* application, gpointer user_data) {
    MyApplication* self = MY_APPLICATION(application);

    // This is called when user clicks dock icon while app is already running
    self->activated_from_dock = TRUE;

    if (self->main_window) {
        // Force fullscreen and bring to top only when activated from dock
        force_fullscreen_and_top(self);
    }
}

static void my_application_activate(GApplication* application) {
    MyApplication* self = MY_APPLICATION(application);

    // If window already exists, handle secondary activation
    if (self->main_window) {
        if (self->activated_from_dock) {
            // Only force fullscreen if activated from dock
            force_fullscreen_and_top(self);
            self->activated_from_dock = FALSE;
        } else {
            // Regular activation - just present without forcing fullscreen
            gtk_window_present(self->main_window);
        }
        return;
    }

    // Create new window for first activation
    GtkWindow* window = GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));
    self->main_window = window;

    // Window manager detection for header bar
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

    // Setup window appearance
    if (use_header_bar) {
        GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
        gtk_widget_show(GTK_WIDGET(header_bar));
        gtk_header_bar_set_title(header_bar, "YourApp");
        gtk_header_bar_set_show_close_button(header_bar, TRUE);
        gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
    } else {
        gtk_window_set_title(window, "YourApp");
    }

    gtk_window_set_default_size(window, 1280, 720);
    gtk_window_set_decorated(window, TRUE);

    // Connect window state event handler
    g_signal_connect(window, "window-state-event", G_CALLBACK(on_window_state_event), self);

    gtk_widget_show(GTK_WIDGET(window));

    // Setup Flutter project
    g_autoptr(FlDartProject) project = fl_dart_project_new();
    fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

    FlView* view = fl_view_new(project);
    gtk_widget_show(GTK_WIDGET(view));
    gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

    fl_register_plugins(FL_PLUGIN_REGISTRY(view));

    gtk_widget_grab_focus(GTK_WIDGET(view));

    // Initial fullscreen setup
    gtk_window_present(window);
    gtk_window_fullscreen(window);
    self->is_fullscreen = TRUE;

    // Allow other apps to show on top by default
    allow_other_apps_on_top(self);
}

static gboolean my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
    MyApplication* self = MY_APPLICATION(application);
    self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

    g_autoptr(GError) error = nullptr;
    if (!g_application_register(application, nullptr, &error)) {
        g_warning("Failed to register: %s", error->message);
        *exit_status = 1;
        return TRUE;
    }

    g_application_activate(application);
    *exit_status = 0;
    return TRUE;
}

static void my_application_startup(GApplication* application) {
    G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

static void my_application_shutdown(GApplication* application) {
    G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

static void my_application_dispose(GObject* object) {
    MyApplication* self = MY_APPLICATION(object);
    g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
    self->main_window = nullptr;
    G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
    G_APPLICATION_CLASS(klass)->activate = my_application_activate;
    G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
    G_APPLICATION_CLASS(klass)->startup = my_application_startup;
    G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
    G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {
    self->main_window = nullptr;
    self->is_fullscreen = FALSE;
    self->activated_from_dock = FALSE;
}

MyApplication* my_application_new() {
    MyApplication* app = MY_APPLICATION(g_object_new(my_application_get_type(),
            "application-id", APPLICATION_ID,
            "flags", G_APPLICATION_HANDLES_COMMAND_LINE,
            nullptr));

    // Connect signal for secondary activation (dock clicks)
    g_signal_connect(app, "activate", G_CALLBACK(on_secondary_activation), nullptr);

    return app;
}