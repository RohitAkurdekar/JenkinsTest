#include <iostream>
#include <string>
#include "akJsonUtils.h"

/**
 * @brief Parses a JSON string into a JSON object.
 * 
 * @param jstr The input JSON string.
 * @param jout The output JSON object.
 * @param isArrChk If true, checks whether the parsed JSON is an array.
 * @return bool True if parsing is successful, false otherwise.
 * 
 * @note Logs an error message if parsing fails or if the array check fails.
 */
bool JsonUtils::parseJsonString(const std::string& jstr, json& jout, bool isArrChk) {
    if (jstr.empty()) {
        std::cerr << "Error: Input JSON string is empty." << std::endl;
        return false;
    }
    // Attempt to parse the JSON string
    try {
        jout = json::parse(jstr);
        if (isArrChk && !jout.is_array()) {
            std::cerr << "Error: JSON is not an array." << std::endl;
            return false;
        }
        return true;
    } catch (const json::parse_error& e) {
        std::cerr << "JSON Parse Error: " << e.what() << std::endl;
        return false;
    }
}

/**
 * @brief Copies a parameter from one JSON object to another.
 * 
 * @param jIn The input JSON object.
 * @param inParam The key of the parameter to copy from the input JSON.
 * @param jOut The output JSON object.
 * @param outParam The key of the parameter to copy to in the output JSON.
 * @return bool True if the parameter is successfully copied, false otherwise.
 * 
 * @note Logs an error message if the input parameter is missing or if an exception occurs.
 */
bool JsonUtils::copyJsonParam(json& jIn, const std::string& inParam, json& jOut, const std::string& outParam) {
    try {
        if (jIn.contains(inParam)) {
            jOut[outParam] = jIn[inParam];
            return true;
        } else {
            std::cerr << "Error: Input JSON does not contain parameter '" << inParam << "'." << std::endl;
            return false;
        }
    } catch (const std::exception& e) {
        std::cerr << "Error while copying JSON parameter: " << e.what() << std::endl;
        return false;
    }
}
