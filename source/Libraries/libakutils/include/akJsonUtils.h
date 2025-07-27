#ifndef AKUTILS_H
#define AKUTILS_H

#include <string>
#include "json.hpp"
using json = nlohmann::json;

/**
 * @class JsonUtils
 * @brief Utility class for JSON operations.
 */
class JsonUtils {
public:
    bool parseJsonString(const std::string& jstr, json& jout, bool isArrChk);
    bool copyJsonParam(json& jIn, const std::string& inParam, json& jOut, const std::string& outParam);
};

#endif // AKUTILS_H
