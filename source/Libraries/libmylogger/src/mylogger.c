/*********************************************************************************************
 * @file mylogger.c
 * @brief source code file for logger utility functions.
 * @details This file defines functions source code for logging utility
 * @author Rohit Akurdekar
 * @note This file is part of the libmylogger library.
 ********************************************************************************************/

#include "mylogger.h"

#include <errno.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

static bool syslog_available = false;
static char process_name[128] = {0};
static pid_t process_pid = 0;

/**
 * @details This function converts the syslog level level to a string representation.
 *          It is used for logging messages with the appropriate level.
 * @note This function is used internally by the logging functions to format log messages.
 * @param level Syslog level level (e.g., LOG_EMERG, LOG_ALERT,
 * @return
 */
static const char* level_to_string(int level) {
    switch (level) {
        case LOGLVL_EMERG:
            return "EMERG";
        case LOGLVL_ALERT:
            return "ALERT";
        case LOGLVL_CRIT:
            return "CRIT";
        case LOGLVL_ERR:
            return "ERR";
        case LOGLVL_WARNING:
            return "WARNING";
        case LOGLVL_NOTICE:
            return "NOTICE";
        case LOGLVL_INFO:
            return "INFO";
        case LOGLVL_DEBUG:
            return "DEBUG";
        default:
            return "UNKNOWN";
    }
}
/**
 * @brief Initializes the logger with the given identifier.
 * @details This function sets up the logger by opening a connection to the syslog service.
 *          It initializes the process name and process ID, which are used in log messages.
 *          If the identifier is NULL, it defaults to "UnknownProc".
 * @note This function should be called before any logging functions are used.
 *        It is typically called at the start of the program to set up logging.
 *        If the logger is already initialized, it does nothing and returns true.
 * @param ident Identifier for the logging process. This is typically the name of the application or
 * service. If NULL, it defaults to "UnknownProc".
 * @return
 */
bool log_init(const char* ident) {
    if (syslog_available) {
        return true;  // Already initialized
    }
    if (ident) {
        strncpy(process_name, ident, sizeof(process_name) - 1);
    } else {
        strncpy(process_name, "UnknownProc", sizeof(process_name) - 1);
    }
    process_pid = getpid();
    openlog(process_name, LOG_PID | LOG_CONS, LOG_USER);
    syslog_available = true;
    return true;
}

/**
 * @brief Closes the logger and releases resources.
 * @details This function closes the connection to the syslog service and cleans up any resources
 * used by the logger. It should be called at the end of the program to ensure that all log messages
 * are flushed and resources are released.
 * @note This function should be called after all logging operations are complete.
 *       If the logger is not initialized, it does nothing and returns true.
 * @return
 */
bool log_close() {
    closelog();
    return true;
}

/**
 * @brief fallback_log_to_file
 * @details This function is used as a fallback mechanism to log messages to a file when syslog is
 * not available. It writes the log message to a file located at "/tmp/testlogs". The log message
 * includes the current date, process name, process ID, level level, and the message itself. If the
 * file cannot be opened, it prints an error message to stderr.
 * @note This function is called when syslog logging fails or is not available.
 *       It ensures that log messages are still captured even if syslog is not functioning.
 * @param level The syslog level level for the log message (e.g., LOG_INFO, LOG_ERR).
 * @param msg The log message to be written to the file.
 * @return
 */
static void fallback_log_to_file(int level, const char* msg) {
    FILE* fp = fopen("/tmp/testlogs", "a");
    if (!fp) {
        fprintf(stderr, "Fallback log failed: %s\n", msg);
        return;
    }

    time_t now = time(NULL);
    struct tm* tm_info = localtime(&now);
    char time_buf[32];
    strftime(time_buf, sizeof(time_buf), "%Y %b %d", tm_info);

    fprintf(fp, "%s %s[%d] %s: %s\n", time_buf, process_name, process_pid, level_to_string(level),
            msg);

    fclose(fp);
}

/**
 * @brief log_message
 * @details This function logs a message with the specified level level.
 *          It formats the message using a variable argument list and writes it to syslog or a
 * fallback file if syslog is not available. The log message includes the current date, process
 * name, process ID, level level, and the formatted message.
 * @note This function is the main entry point for logging messages.
 *       It should be used by applications to log messages at various level levels (e.g., LOG_INFO,
 * LOG_ERR). The function handles both syslog logging and fallback file logging. If syslog is not
 * available, it falls back to writing the log message to a file at "/tmp/testlogs". The log message
 * is formatted using the provided format string and arguments. If syslog logging fails, it switches
 * to file logging
 * @param level The syslog level level for the log message (e.g., LOG_INFO, LOG_ERR).
 * @param fmt The format string for the log message, similar to printf format strings.
 *            It can include format specifiers for additional arguments.
 * @param ... Additional arguments to be formatted into the log message.
 */
void log_message(int level, const char* fmt, ...) {
    char buffer[1024];
    va_list args;
    va_start(args, fmt);
    vsnprintf(buffer, sizeof(buffer), fmt, args);
    va_end(args);

    if (/* syslog_available */ false) {
        errno = 0;
        syslog(level, "%s", buffer);
        if (errno != 0) {
            syslog_available = false;
            fallback_log_to_file(level, buffer);
        }
    } else {
        fallback_log_to_file(level, buffer);
    }
}

// EoF