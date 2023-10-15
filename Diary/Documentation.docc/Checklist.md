# Checklists
These are the checklists that must be used on code piece

## Overview
Every piece of code must accord to one format to be clean, easily readable and understandable. That's why you must these cheklists must be used on every piece of code.

### Checklists
1. __Mixed__
2. __Logging__
3. __In code documentation__

# 1. Mixed
### 1.1 Class/struct
* There's a documentation that contains the purpose of the class/struct
* At the begin there's a private logger constant with subsystem and category parameters filled in
```
/// Used for CRUD operation with diary entries
struct DiaryEntry {
    private let logger: Logger = Logger(subsystem: "...", category: "...")
    ...
}
```

### 1.2 Function
* At the begin there's a __logger.info__ command with text '**Starting to (FUNCTION DESCRIPTION)...**' 
* At the end if function is successfull there's a __logger.info()__ command with text '**Successfully (FUNCTION DESCRIPTION)**'
* If function failes, gets value it shouldn't get (like a **nil**) or an error, there's a __logger.critical()__ command with error description and description of next steps (optional)
    ```
    func loadDiaryEntries() {
        logger.info("Starting to load diary entries...")
        ...
        guard let object = ... else {
            logger.critical("object is nil, saving empty array")
        ...
        }
        ...
        do {
            ...
            logger.info("Successfully loaded diary entries")
        } catch {
            logger.critical("Failed to load diary entries: \(error.localizedDescription)")
            ...
        }
    }
    ```

### 1.3 Enum/extension
* There's a documentation that contains the purpose of the enum/extension

# 2. Logging
### 2.2 Class/struct
* At the begin there's a private logger constant with subsystem and category parameters filled in
    ```
    private let logger: Logger = Logger(subsystem: "...", category: "...")
    ```

### 2.2 Function
* At the begin there's a __logger.info__ command with text '**Starting to (FUNCTION DESCRIPTION)...**' 
* At the end if function is successfull there's a __logger.info()__ command with text '**Successfully (FUNCTION DESCRIPTION)**'
* If function failes, gets value it shouldn't get (like a **nil**) or an error, there's a __logger.critical()__ command with error description and description of next steps (optional)
    ```
    func loadDiaryEntries() {
        logger.info("Starting to load diary entries...")
        ...
        guard let object = ... else {
            logger.critical("object is nil, saving empty array")
        ...
        }
        ...
        do {
            ...
            logger.info("Successfully loaded diary entries")
        } catch {
            logger.critical("Failed to load diary entries: \(error.localizedDescription)")
            ...
        }
    }
    ```

# 3. In code documentation
<!--### 3.1 Class/struct-->
* Every class/struct/func/extension/enum has a description that contains the  purpose of the following code piece
* Every documentation is completed and actualized
