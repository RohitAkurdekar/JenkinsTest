# testMain.cpp - JSON Utilities Test Application

This file defines a simple C++ test application that demonstrates and verifies the functionality of the custom `JsonUtils` library.

---

## 📄 File Overview

- **Filename:** `testMain.cpp`
- **Purpose:** Validate and demonstrate JSON utility functions such as parsing and copying JSON elements.
- **Author:** Rohit Akurdekar

---

## 🔧 Features Tested

### ✅ `JsonUtils::parseJsonString`

Parses a JSON string into a `json` object.

- **Input:**

  ```json
  {
    "key1": "value1",
    "key2": {
      "nestedKey": "nestedValue"
    }
  }
  ```

- **Output on success:**
  Printed parsed JSON content using `inputJson.dump()`

---

### ✅ `JsonUtils::copyJsonParam`

Copies a nested JSON parameter from one object to another under a different key.

- **Example:**
  Copies `key2` from `inputJson` to `outputJson` as `copiedKey`.

- **Expected output:**
  ```json
  {
    "copiedKey": {
      "nestedKey": "nestedValue"
    }
  }
  ```

---

## 🔁 How It Works

```cpp
json inputJson, outputJson;
std::string jsonString = R"({"key1": "value1", "key2": {"nestedKey": "nestedValue"}})";

if (JsonUtils::parseJsonString(jsonString, inputJson, false)) {
    std::cout << "parseJsonString passed: " << inputJson.dump() << std::endl;
}

if (JsonUtils::copyJsonParam(inputJson, "key2", outputJson, "copiedKey")) {
    std::cout << "copyJsonParam passed: " << outputJson.dump() << std::endl;
}
```

---

## 🧪 Output Example

```
parseJsonString passed: {"key1":"value1","key2":{"nestedKey":"nestedValue"}}
copyJsonParam passed: {"copiedKey":{"nestedKey":"nestedValue"}}
```

---

## 🧵 Dependencies

- [nlohmann/json](https://github.com/nlohmann/json) — for JSON parsing
- `akJsonUtils.h` — custom JSON utility functions defined in your `libakutils` library

---

## 📦 How to Build & Run

```bash
cd source/Applications/test-bin
make
./test-bin
```

Ensure that your build environment includes the `nlohmann/json` library and your `libakutils`.

---

## 🧑‍💻 Author

**Rohit Akurdekar**
🔗 [GitHub Profile](https://github.com/RohitAkurdekar)
