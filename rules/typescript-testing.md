# TypeScript Testing Rules

Best practices and coding standards for writing tests in TypeScript or in JavaScript with Jest.

## Core Principles

### 1. Test Organization with `describe` Blocks

**Rule:** Group tests for one functionality in a single `describe` block.

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a new user with valid data', () => {
      // test implementation
    });

    it('should throw an error when email is invalid', () => {
      // test implementation
    });
  });

  describe('deleteUser', () => {
    it('should delete an existing user', () => {
      // test implementation
    });
  });
});
```

**Benefits:**
- Clear test hierarchy
- Easy navigation in test reports
- Logical grouping of related tests

### 2. One Test Case Per `it` Block

**Rule:** Each `it` block should test exactly one specific behavior or scenario.

❌ **Bad:**
```typescript
it('should handle user operations', () => {
  // Testing creation
  const user = createUser({ name: 'John' });
  expect(user).toBeDefined();

  // Testing update
  updateUser(user.id, { name: 'Jane' });
  expect(user.name).toBe('Jane');

  // Testing deletion
  deleteUser(user.id);
  expect(getUser(user.id)).toBeNull();
});
```

✅ **Good:**
```typescript
it('should create a user with valid data', () => {
  const user = createUser({ name: 'John' });
  expect(user).toBeDefined();
  expect(user.name).toBe('John');
});

it('should update user name', () => {
  const user = createUser({ name: 'John' });
  updateUser(user.id, { name: 'Jane' });
  expect(user.name).toBe('Jane');
});

it('should delete an existing user', () => {
  const user = createUser({ name: 'John' });
  deleteUser(user.id);
  expect(getUser(user.id)).toBeNull();
});
```

### 3. Setup in `beforeEach`

**Rule:** Initialize imports, providers, mocks, and common test data in `beforeEach` hooks.

```typescript
describe('UserController', () => {
  let userController: UserController;
  let userService: jest.Mocked<UserService>;
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;

  beforeEach(() => {
    // Setup mocks
    userService = {
      findUser: jest.fn(),
      createUser: jest.fn(),
      updateUser: jest.fn(),
      deleteUser: jest.fn(),
    } as jest.Mocked<UserService>;

    // Setup common test objects
    mockRequest = {
      body: {},
      params: {},
    };

    mockResponse = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    };

    // Initialize the system under test
    userController = new UserController(userService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  // tests...
});
```

**Benefits:**
- Each test starts with a clean state
- Reduces code duplication
- Makes tests more maintainable

### 4. Given-When-Then Pattern

**Rule:** Structure every test using the Given-When-Then pattern with explicit comments.

```typescript
it('should return 404 when user is not found', async () => {
  // given
  const userId = '123';
  mockRequest.params = { id: userId };
  userService.findUser.mockResolvedValue(null);

  // when
  await userController.getUser(mockRequest as Request, mockResponse as Response);

  // then
  expect(userService.findUser).toHaveBeenCalledWith(userId);
  expect(mockResponse.status).toHaveBeenCalledWith(404);
  expect(mockResponse.json).toHaveBeenCalledWith({
    error: 'User not found',
  });
});
```

**Pattern Breakdown:**
- **Given** - Set up test data, mocks, and preconditions
- **When** - Execute the action being tested
- **Then** - Assert the expected outcomes

### 5. Test Naming Convention

**Rule:** Test names should clearly describe what is being tested and the expected outcome.

**Format:** `should [expected behavior] when [condition]`

✅ **Good:**
```typescript
it('should return user data when user exists', () => {});
it('should throw ValidationError when email is invalid', () => {});
it('should call callback with success status when operation completes', () => {});
```

❌ **Bad:**
```typescript
it('works', () => {});
it('test user', () => {});
it('handles errors', () => {});
```

### 6. Mock Management

**Rule:** Always clean up mocks after each test to prevent test pollution.

```typescript
describe('PaymentService', () => {
  let paymentGateway: jest.Mocked<PaymentGateway>;

  beforeEach(() => {
    paymentGateway = {
      charge: jest.fn(),
      refund: jest.fn(),
    } as jest.Mocked<PaymentGateway>;
  });

  afterEach(() => {
    jest.clearAllMocks(); // Clear mock call history
    // or
    jest.resetAllMocks(); // Clear + reset implementations
    // or
    jest.restoreAllMocks(); // Restore original implementations
  });

  it('should process payment successfully', () => {
    // given
    paymentGateway.charge.mockResolvedValue({ success: true });

    // when
    const result = await processPayment(100);

    // then
    expect(paymentGateway.charge).toHaveBeenCalledWith(100);
    expect(result.success).toBe(true);
  });
});
```

**Mock Cleanup Methods:**
- `jest.clearAllMocks()` - Clears mock call history and results
- `jest.resetAllMocks()` - Clears + resets mock implementations
- `jest.restoreAllMocks()` - Restores original implementations (for spies)

### 7. Async/Await Handling

**Rule:** Always use `async/await` for asynchronous tests and handle rejections properly.

✅ **Good:**
```typescript
it('should fetch user data from API', async () => {
  // given
  const userId = '123';
  const expectedUser = { id: userId, name: 'John' };
  mockApiClient.get.mockResolvedValue(expectedUser);

  // when
  const user = await userService.fetchUser(userId);

  // then
  expect(user).toEqual(expectedUser);
  expect(mockApiClient.get).toHaveBeenCalledWith(`/users/${userId}`);
});

it('should handle API errors gracefully', async () => {
  // given
  const error = new Error('Network error');
  mockApiClient.get.mockRejectedValue(error);

  // when & then
  await expect(userService.fetchUser('123')).rejects.toThrow('Network error');
});
```

❌ **Bad:**
```typescript
it('should fetch user data from API', (done) => {
  userService.fetchUser('123').then((user) => {
    expect(user).toBeDefined();
    done();
  });
});
```

### 8. Test Isolation

**Rule:** Each test must be independent and not rely on the state from other tests.

❌ **Bad:**
```typescript
let sharedUser: User;

it('should create a user', () => {
  sharedUser = createUser({ name: 'John' });
  expect(sharedUser).toBeDefined();
});

it('should update the user', () => {
  // Depends on previous test!
  updateUser(sharedUser.id, { name: 'Jane' });
  expect(sharedUser.name).toBe('Jane');
});
```

✅ **Good:**
```typescript
describe('User operations', () => {
  let testUser: User;

  beforeEach(() => {
    // Each test gets a fresh user
    testUser = createUser({ name: 'John' });
  });

  it('should create a user', () => {
    expect(testUser).toBeDefined();
    expect(testUser.name).toBe('John');
  });

  it('should update user name', () => {
    // given
    const newName = 'Jane';

    // when
    updateUser(testUser.id, { name: newName });

    // then
    expect(testUser.name).toBe(newName);
  });
});
```

### 9. Type Safety in TestScript Tests

**Rule:** Use proper TypeScript types in tests, including for mocks and test data.

```typescript
import { User, UserCreateInput, UserService } from './user.service';

describe('UserService', () => {
  let userService: UserService;
  let mockRepository: jest.Mocked<UserRepository>;

  beforeEach(() => {
    mockRepository = {
      save: jest.fn(),
      findById: jest.fn(),
      delete: jest.fn(),
    } as jest.Mocked<UserRepository>;

    userService = new UserService(mockRepository);
  });

  it('should create a user with proper type', async () => {
    // given
    const input: UserCreateInput = {
      name: 'John Doe',
      email: 'john@example.com',
      age: 30,
    };

    const expectedUser: User = {
      id: '123',
      ...input,
      createdAt: new Date(),
    };

    mockRepository.save.mockResolvedValue(expectedUser);

    // when
    const result: User = await userService.createUser(input);

    // then
    expect(result).toEqual(expectedUser);
    expect(mockRepository.save).toHaveBeenCalledWith(input);
  });
});
```

### 10. Test Data Builders

**Rule:** Use factory functions or builders for complex test data creation.

```typescript
// test-helpers/user.factory.ts
export const createTestUser = (overrides?: Partial<User>): User => ({
  id: '123',
  name: 'John Doe',
  email: 'john@example.com',
  role: 'user',
  isActive: true,
  createdAt: new Date('2024-01-01'),
  ...overrides,
});

export const createTestAdmin = (overrides?: Partial<User>): User =>
  createTestUser({
    role: 'admin',
    ...overrides,
  });

// In tests
describe('UserPermissions', () => {
  it('should allow admin to delete users', () => {
    // given
    const admin = createTestAdmin();
    const targetUser = createTestUser({ id: '456' });

    // when
    const canDelete = checkPermission(admin, 'delete', targetUser);

    // then
    expect(canDelete).toBe(true);
  });

  it('should deny regular user from deleting other users', () => {
    // given
    const regularUser = createTestUser();
    const targetUser = createTestUser({ id: '456' });

    // when
    const canDelete = checkPermission(regularUser, 'delete', targetUser);

    // then
    expect(canDelete).toBe(false);
  });
});
```

### 11. Coverage Expectations

**Rule:** Aim for meaningful coverage, not just high percentages.

**Minimum Coverage Targets:**
- Statements: 80%
- Branches: 75%
- Functions: 80%
- Lines: 80%

**Focus On:**
- Critical business logic (100% coverage)
- Error handling paths
- Edge cases and boundary conditions
- Public API methods

**Can Skip:**
- Simple getters/setters
- Type definitions
- Configuration files
- Test utilities

### 12. Error Testing

**Rule:** Always test both success and error scenarios.

```typescript
describe('UserValidator', () => {
  describe('validateEmail', () => {
    it('should return true for valid email', () => {
      // given
      const validEmail = 'user@example.com';

      // when
      const result = validateEmail(validEmail);

      // then
      expect(result).toBe(true);
    });

    it('should return false for email without @', () => {
      // given
      const invalidEmail = 'userexample.com';

      // when
      const result = validateEmail(invalidEmail);

      // then
      expect(result).toBe(false);
    });

    it('should return false for email without domain', () => {
      // given
      const invalidEmail = 'user@';

      // when
      const result = validateEmail(invalidEmail);

      // then
      expect(result).toBe(false);
    });

    it('should return false for empty string', () => {
      // given
      const emptyEmail = '';

      // when
      const result = validateEmail(emptyEmail);

      // then
      expect(result).toBe(false);
    });
  });
});
```

## File Organization

### Test File Naming

**Rule:** Place test files next to the files they test with `.test.ts` or `.spec.ts` suffix.

```
src/
├── services/
│   ├── user.service.ts
│   ├── user.service.test.ts      # ✅ Preferred
│   └── user.service.spec.ts      # ✅ Alternative
```

### Test File Structure

```typescript
// 1. Imports
import { UserService } from './user.service';
import { UserRepository } from './user.repository';

// 2. Test data / constants
const VALID_EMAIL = 'test@example.com';
const INVALID_EMAIL = 'invalid-email';

// 3. Main describe block
describe('UserService', () => {
  // 4. Test variables
  let userService: UserService;
  let mockRepository: jest.Mocked<UserRepository>;

  // 5. Setup
  beforeEach(() => {
    mockRepository = createMockRepository();
    userService = new UserService(mockRepository);
  });

  // 6. Teardown
  afterEach(() => {
    jest.clearAllMocks();
  });

  // 7. Nested describe blocks for each method
  describe('createUser', () => {
    it('should create user with valid data', () => {
      // test implementation
    });

    it('should throw error with invalid email', () => {
      // test implementation
    });
  });

  describe('findUser', () => {
    // tests...
  });
});
```

## Common Patterns

### Testing Private Methods

**Rule:** Test private methods indirectly through public API.

❌ **Bad:**
```typescript
it('should validate email format', () => {
  // @ts-ignore - accessing private method
  expect(userService['validateEmail']('test@example.com')).toBe(true);
});
```

✅ **Good:**
```typescript
it('should reject user creation with invalid email', () => {
  // given
  const invalidUser = { name: 'John', email: 'invalid-email' };

  // when & then
  expect(() => userService.createUser(invalidUser)).toThrow('Invalid email');
});
```

### Testing Callbacks

```typescript
it('should call callback with success result', (done) => {
  // given
  const callback = jest.fn((error, result) => {
    // then
    expect(error).toBeNull();
    expect(result).toEqual({ success: true });
    done();
  });

  // when
  processAsync(callback);
});

// Or with async/await (preferred)
it('should call callback with success result', async () => {
  // given
  const callback = jest.fn();

  // when
  await processAsync(callback);

  // then
  expect(callback).toHaveBeenCalledWith(null, { success: true });
});
```

### Testing Timers

```typescript
describe('RetryService', () => {
  beforeEach(() => {
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  it('should retry after delay', () => {
    // given
    const mockFn = jest.fn();

    // when
    scheduleRetry(mockFn, 1000);

    // then
    expect(mockFn).not.toHaveBeenCalled();

    jest.advanceTimersByTime(1000);

    expect(mockFn).toHaveBeenCalledTimes(1);
  });
});
```

## Anti-Patterns to Avoid

### ❌ Testing Implementation Details

```typescript
// Bad - testing internal state
it('should set isLoading to true', () => {
  component.fetchData();
  expect(component.isLoading).toBe(true);
});

// Good - testing observable behavior
it('should show loading spinner while fetching', () => {
  component.fetchData();
  expect(getLoadingSpinner()).toBeVisible();
});
```

### ❌ Multiple Assertions Without Context

```typescript
// Bad
it('should work correctly', () => {
  const result = processData(input);
  expect(result.status).toBe('success');
  expect(result.data.length).toBe(5);
  expect(result.timestamp).toBeDefined();
  expect(result.error).toBeNull();
});

// Good - separate concerns
describe('processData', () => {
  it('should return success status', () => {
    const result = processData(input);
    expect(result.status).toBe('success');
  });

  it('should process all 5 items', () => {
    const result = processData(input);
    expect(result.data.length).toBe(5);
  });

  it('should include timestamp', () => {
    const result = processData(input);
    expect(result.timestamp).toBeDefined();
  });

  it('should not contain errors', () => {
    const result = processData(input);
    expect(result.error).toBeNull();
  });
});
```

### ❌ Unclear Test Names

```typescript
// Bad
it('test1', () => {});
it('should work', () => {});
it('edge case', () => {});

// Good
it('should return empty array when input is null', () => {});
it('should throw ValidationError when age is negative', () => {});
it('should handle maximum integer value correctly', () => {});
```

## Quick Reference Checklist

Before submitting tests, verify:

- [ ] Each functionality has its own `describe` block
- [ ] Each test case has its own `it` block
- [ ] Setup is done in `beforeEach`, cleanup in `afterEach`
- [ ] Every test follows Given-When-Then pattern with comments
- [ ] Test names clearly describe behavior and conditions
- [ ] Mocks are properly typed and cleaned up
- [ ] Async operations use `async/await`
- [ ] Tests are isolated and independent
- [ ] Both success and error paths are tested
- [ ] Test data uses factory functions for complex objects
- [ ] Type safety is maintained throughout tests

## Resources

- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [Testing Best Practices](https://github.com/goldbergyoni/javascript-testing-best-practices)
- [TypeScript Deep Dive - Testing](https://basarat.gitbook.io/typescript/intro-1/jest)
