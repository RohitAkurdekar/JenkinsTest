/*********************************************************************************************
 * @file mylogger.h
 * @brief Header file for logger utility functions.
 * @details This file declares functions for logging utility
 * @author Rohit Akurdekar
 * @note This file is part of the libmylogger library.
 ********************************************************************************************/

#ifndef MYLOGGER_H
#define MYLOGGER_H

#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <syslog.h>

enum logLvl {
    LOGLVL_EMERG = 0,
    LOGLVL_ALERT,
    LOGLVL_CRIT,
    LOGLVL_ERR,
    LOGLVL_WARNING,
    LOGLVL_NOTICE,
    LOGLVL_INFO,
    LOGLVL_DEBUG
};

bool log_init(const char* ident);
bool log_close();

void log_message(int priority, const char* fmt, ...);

#define MYLOG_INFO(fmt, ...) log_message(LOGLVL_INFO, fmt, ##__VA_ARGS__)
#define MYLOG_ERR(fmt, ...) log_message(LOGLVL_ERR, fmt, ##__VA_ARGS__)
#define MYLOG_DEBUG(fmt, ...) log_message(LOGLVL_DEBUG, fmt, ##__VA_ARGS__)
#define MYLOG_WARNING(fmt, ...) log_message(LOGLVL_WARNING, fmt, ##__VA_ARGS__)
#define MYLOG_NOTICE(fmt, ...) log_message(LOGLVL_NOTICE, fmt, ##__VA_ARGS__)
#define MYLOG_ALERT(fmt, ...) log_message(LOGLVL_ALERT, fmt, ##__VA_ARGS__)
#define MYLOG_CRIT(fmt, ...) log_message(LOGLVL_CRIT, fmt, ##__VA_ARGS__)
#define MYLOG_EMERG(fmt, ...) log_message(LOGLVL_EMERG, fmt, ##__VA_ARGS__)

#endif  // MYLOGGER_H