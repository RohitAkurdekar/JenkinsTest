#include "testMain.h"

int main() {
    json inputJson, outputJson;
    std::string jsonString = R"({"key1": "value1", "key2": {"nestedKey": "nestedValue"}})";

    // Test parseJsonString
    if (JsonUtils::parseJsonString(jsonString, inputJson, false)) {
        std::cout << "parseJsonString passed: " << inputJson.dump() << std::endl;
    } else {
        std::cerr << "parseJsonString failed" << std::endl;
    }

    // Test copyJsonParam
    if (JsonUtils::copyJsonParam(inputJson, "key2", outputJson, "copiedKey")) {
        std::cout << "copyJsonParam passed: " << outputJson.dump() << std::endl;
    } else {
        std::cerr << "copyJsonParam failed" << std::endl;
    }

    return 0;
}
