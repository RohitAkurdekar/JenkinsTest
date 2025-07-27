# nlohmann/json

The **nlohmann/json** library is a modern C++ library for working with JSON. It provides an easy-to-use, header-only solution for parsing, serializing, and manipulating JSON data.

## Features
- **Header-only**: No need for additional dependencies.
- **STL-like API**: Seamlessly integrates with standard C++ containers.
- **Serialization/Deserialization**: Convert JSON to C++ objects and vice versa.
- **JSON Pointer and Patch**: Supports JSON Pointer and JSON Patch standards.
- **Wide Compatibility**: Works with C++11 and later.

## Example Usage
```cpp
#include <nlohmann/json.hpp>
using json = nlohmann::json;

int main() {
    // Create JSON object
    json j = {{"name", "John"}, {"age", 30}, {"is_student", false}};

    // Access values
    std::string name = j["name"];
    int age = j["age"];

    // Serialize to string
    std::string jsonString = j.dump();

    // Parse from string
    json parsed = json::parse(jsonString);

    return 0;
}
```

For more details, visit the [official GitHub repository](https://github.com/nlohmann/json).