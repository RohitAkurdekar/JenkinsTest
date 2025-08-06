# akJsonUtils.cpp - JSON Utility Functions

This file provides core utility functions for JSON parsing and manipulation using the [nlohmann/json](https://github.com/nlohmann/json) library. It is part of the custom `libakutils` library and helps safely parse JSON strings and copy elements between objects.

---

## 📄 File Overview

- **Filename:** `akJsonUtils.cpp`
- **Purpose:** Implements robust and reusable JSON utilities
- **Author:** Rohit Akurdekar

---

## 🔧 Implemented Functions

### ✅ `JsonUtils::parseJsonString`

Parses a string into a JSON object.

#### **Signature**

```cpp
bool JsonUtils::parseJsonString(const std::string& jstr, json& jout, bool isArrChk)
```

#### **Parameters**

- `jstr`: Input string to parse.
- `jout`: Output JSON object.
- `isArrChk`: If `true`, function checks that the parsed JSON is an array.

#### **Behavior**

- Returns `true` if parsing is successful.
- If `isArrChk` is `true` and the JSON is not an array, returns `false`.
- Logs errors on failure.

#### **Example**

```cpp
std::string input = R"({"items": [1, 2, 3]})";
json j;
JsonUtils::parseJsonString(input, j, false);
```

---

### ✅ `JsonUtils::copyJsonParam`

Copies a field from one JSON object to another under a new key.

#### **Signature**

```cpp
bool JsonUtils::copyJsonParam(json& jIn, const std::string& inParam, json& jOut, const std::string& outParam)
```

#### **Parameters**

- `jIn`: Source JSON object.
- `inParam`: Key in source to copy.
- `jOut`: Destination JSON object.
- `outParam`: New key in destination.

#### **Behavior**

- Copies data if key exists in source.
- Logs an error if the key is missing or an exception is thrown.

#### **Example**

```cpp
json inJson = {{"foo", "bar"}};
json outJson;
JsonUtils::copyJsonParam(inJson, "foo", outJson, "copiedFoo");
```

---

## 🧵 Dependencies

- [nlohmann/json](https://github.com/nlohmann/json)
- Standard C++ library

---

## ✅ Error Handling

- Logs detailed error messages to `std::cerr` for invalid input, parsing issues, and missing keys.

---

## 🧪 Example Output

```
parseJsonString passed: {"key1":"value1","key2":{"nestedKey":"nestedValue"}}
copyJsonParam passed: {"copiedKey":{"nestedKey":"nestedValue"}}
```

---

## 🧑‍💻 Author

**Rohit Akurdekar**
🔗 [GitHub Profile](https://github.com/RohitAkurdekar)
