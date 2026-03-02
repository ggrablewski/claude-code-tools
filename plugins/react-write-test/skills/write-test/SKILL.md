---
name: write-test
description: Use this skill when the user asks to "write tests", "create tests", "add test coverage", "test this component", or mentions testing React/React Native components. This skill defines my preferred testing approach using Jest and React Testing Library.
user-invokable: true
disable-model-invocation: false
---

# write-test Skill

This skill provides guidance for writing comprehensive tests for React and React Native components using Jest and React Testing Library.

## Core Testing Philosophy

### Testing Framework
- **Always use Jest** as the testing framework
- Use **React Testing Library** (`@testing-library/react-native` for React Native)
- File naming: `ComponentName.test.js` (NOT `.spec.js`)
- Place test files next to the component they test

### Test Structure
Each test file should include:
1. **Imports and Setup** - Import component, testing utilities, and mocks
2. **Mock Setup** - Mock external dependencies (AsyncStorage, Audio, etc.)
3. **Test Suites** - Group related tests with `describe` blocks
4. **Individual Tests** - Each test should verify one specific behavior

### Accessibility First
- Always test components with accessibility in mind
- Use `getByRole`, `getByLabelText`, `getByA11yLabel` for querying elements
- Ensure components have proper `accessibilityRole` and `accessibilityLabel` attributes
- Test keyboard navigation and screen reader compatibility

## Test Categories to Cover

### 1. Rendering Tests
```javascript
it('renders correctly with default props', () => {
  const { getByText } = render(<Component />);
  expect(getByText('Expected Text')).toBeTruthy();
});
```

### 2. User Interaction Tests
```javascript
it('calls onPress when button is pressed', () => {
  const mockOnPress = jest.fn();
  const { getByRole } = render(<Component onPress={mockOnPress} />);
  fireEvent.press(getByRole('button'));
  expect(mockOnPress).toHaveBeenCalledTimes(1);
});
```

### 3. Conditional Rendering Tests
```javascript
it('shows error message when error prop is provided', () => {
  const { getByText } = render(<Component error="Error message" />);
  expect(getByText('Error message')).toBeTruthy();
});
```

### 4. State Management Tests
```javascript
it('updates state when user types in input', () => {
  const { getByPlaceholderText } = render(<Component />);
  const input = getByPlaceholderText('Enter name');
  fireEvent.changeText(input, 'New value');
  expect(input.props.value).toBe('New value');
});
```

### 5. Accessibility Tests
```javascript
it('has correct accessibility attributes', () => {
  const { getByRole } = render(<Component />);
  const button = getByRole('button');
  expect(button.props.accessibilityLabel).toBe('Submit button');
});
```

### 6. Edge Cases and Error Handling
```javascript
it('handles empty data gracefully', () => {
  const { getByText } = render(<Component data={[]} />);
  expect(getByText('No data available')).toBeTruthy();
});
```

## Required Test Configuration Files

### jest.config.js
```javascript
module.exports = {
  preset: 'react-native',
  setupFiles: ['<rootDir>/jest.polyfills.js'],
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  transformIgnorePatterns: [
    'node_modules/(?!(react-native|@react-native|@react-navigation|expo-.*)/)'
  ],
  coverageReporters: ['html', 'text', 'lcov', 'json-summary'],
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'components/**/*.{js,jsx}',
    '!**/*.test.{js,jsx}',
    '!**/node_modules/**',
  ],
};
```

### jest.setup.js
Mock common React Native and Expo modules:
```javascript
// Mock AsyncStorage
jest.mock('@react-native-async-storage/async-storage', () => ({
  setItem: jest.fn(),
  getItem: jest.fn(),
  removeItem: jest.fn(),
}));

// Mock Expo Audio
jest.mock('expo-av', () => ({
  Audio: {
    Sound: {
      createAsync: jest.fn(() => Promise.resolve({
        sound: {
          playAsync: jest.fn(),
          unloadAsync: jest.fn(),
        },
      })),
    },
  },
}));
```

### babel.config.js
```javascript
module.exports = function(api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
  };
};
```

## Coverage Requirements
- Aim for **80%+ coverage** for all components
- Focus on testing behavior, not implementation details
- Ensure all user-facing features are tested
- Don't skip edge cases and error scenarios

## VS Code Integration
Configure VS Code for inline test running:
1. Install `orta.vscode-jest` extension
2. Install `ryanluker.vscode-coverage-gutters` extension
3. Configure `.vscode/settings.json`:
```json
{
  "jest.autoRun": "off",
  "jest.jestCommandLine": "npm test --",
  "jest.runMode": "on-demand"
}
```

## TypeScript Testing Rules (CRITICAL)

When writing tests in TypeScript, follow these mandatory rules:

### 1. Test Organization with `describe` Blocks

**RULE:** Group tests for one functionality in a single `describe` block.

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a new user with valid data', () => {});
    it('should throw an error when email is invalid', () => {});
  });

  describe('deleteUser', () => {
    it('should delete an existing user', () => {});
  });
});
```

### 2. One Test Case Per `it` Block

**RULE:** Each `it` block must test exactly ONE specific behavior.

### 3. Setup in `beforeEach`

**RULE:** ALL imports, providers, mocks, and common test data MUST be initialized in `beforeEach` hooks.

```typescript
describe('UserController', () => {
  let userController: UserController;
  let mockService: jest.Mocked<UserService>;
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;

  beforeEach(() => {
    // Setup mocks
    mockService = {
      findUser: jest.fn(),
      createUser: jest.fn(),
    } as jest.Mocked<UserService>;

    // Setup common objects
    mockRequest = { body: {}, params: {} };
    mockResponse = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };

    // Initialize system under test
    userController = new UserController(mockService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });
});
```

### 4. Given-When-Then Pattern (MANDATORY)

**RULE:** EVERY test MUST use the Given-When-Then pattern with explicit `// Given`, `// When`, `// Then` comments.

```typescript
it('should return 404 when user is not found', async () => {
  // Given
  const userId = '123';
  mockRequest.params = { id: userId };
  mockService.findUser.mockResolvedValue(null);

  // When
  await userController.getUser(mockRequest as Request, mockResponse as Response);

  // Then
  expect(mockService.findUser).toHaveBeenCalledWith(userId);
  expect(mockResponse.status).toHaveBeenCalledWith(404);
  expect(mockResponse.json).toHaveBeenCalledWith({ error: 'User not found' });
});
```

**Pattern Breakdown:**
- **// Given** - Set up test data, mocks, and preconditions
- **// When** - Execute the action being tested
- **// Then** - Assert the expected outcomes

### 5. Test Naming Convention

**RULE:** Format: `should [expected behavior] when [condition]`

✅ Good:
- `should return user data when user exists`
- `should throw ValidationError when email is invalid`

❌ Bad:
- `works`
- `test user`
- `handles errors`

### 6. Mock Management

**RULE:** Always clean up mocks in `afterEach` to prevent test pollution.

```typescript
afterEach(() => {
  jest.clearAllMocks(); // Clear mock call history
});
```

### 7. Async/Await Handling

**RULE:** Always use `async/await` for asynchronous tests.

```typescript
it('should fetch user data from API', async () => {
  // Given
  const userId = '123';
  mockApiClient.get.mockResolvedValue({ id: userId, name: 'John' });

  // When
  const user = await userService.fetchUser(userId);

  // Then
  expect(user.name).toBe('John');
});

it('should handle API errors gracefully', async () => {
  // Given
  mockApiClient.get.mockRejectedValue(new Error('Network error'));

  // When & Then
  await expect(userService.fetchUser('123')).rejects.toThrow('Network error');
});
```

### 8. Type Safety in Tests

**RULE:** Use proper TypeScript types in tests, including for mocks and test data.

```typescript
import { User, UserCreateInput, UserService } from './user.service';

describe('UserService', () => {
  let userService: UserService;
  let mockRepository: jest.Mocked<UserRepository>;

  beforeEach(() => {
    mockRepository = {
      save: jest.fn(),
      findById: jest.fn(),
    } as jest.Mocked<UserRepository>;

    userService = new UserService(mockRepository);
  });

  it('should create a user with proper types', async () => {
    // Given
    const input: UserCreateInput = {
      name: 'John Doe',
      email: 'john@example.com',
    };

    const expectedUser: User = {
      id: '123',
      ...input,
      createdAt: new Date(),
    };

    mockRepository.save.mockResolvedValue(expectedUser);

    // When
    const result: User = await userService.createUser(input);

    // Then
    expect(result).toEqual(expectedUser);
  });
});
```

### 9. Test Isolation

**RULE:** Each test must be independent and not rely on state from other tests.

✅ Good: Each test gets fresh data via `beforeEach`
❌ Bad: Tests share variables and depend on execution order

### 10. Test Data Builders

**RULE:** Use factory functions for complex test data.

```typescript
// test-helpers/user.factory.ts
export const createTestUser = (overrides?: Partial<User>): User => ({
  id: '123',
  name: 'John Doe',
  email: 'john@example.com',
  role: 'user',
  ...overrides,
});

// In tests
it('should allow admin to delete users', () => {
  // Given
  const admin = createTestUser({ role: 'admin' });
  const targetUser = createTestUser({ id: '456' });

  // When
  const canDelete = checkPermission(admin, 'delete', targetUser);

  // Then
  expect(canDelete).toBe(true);
});
```

## Best Practices

### DO:
- ✅ Use descriptive test names that explain what is being tested
- ✅ Test user-facing behavior, not implementation details
- ✅ Mock external dependencies (API calls, storage, audio)
- ✅ Use `data-testid` sparingly - prefer semantic queries
- ✅ Test accessibility attributes and roles
- ✅ Cover edge cases and error states
- ✅ Keep tests simple and focused on one thing
- ✅ **ALWAYS use Given-When-Then comments in every test**
- ✅ **Initialize all mocks and data in beforeEach**
- ✅ **Group related tests in describe blocks**

### DON'T:
- ❌ Test implementation details (internal state, method names)
- ❌ Use `.spec.js` naming (use `.test.js` instead)
- ❌ Skip accessibility testing
- ❌ Write tests that depend on each other
- ❌ Mock everything - only mock external dependencies
- ❌ Ignore TypeScript types in test files (if using TypeScript)
- ❌ **Skip Given-When-Then comments**
- ❌ **Setup test data outside beforeEach**
- ❌ **Test multiple behaviors in one `it` block**

## Example: Complete Component Test

```javascript
import React from 'react';
import { render, fireEvent } from '@testing-library/react-native';
import Card from './Card';

describe('Card Component', () => {
  const mockCard = { id: '1', value: 'A', isFlipped: false, isMatched: false };
  const mockOnCardClick = jest.fn();

  const defaultProps = {
    card: mockCard,
    onCardClick: mockOnCardClick,
    showAllCards: false,
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering', () => {
    it('renders correctly with default props', () => {
      const { getByRole } = render(<Card {...defaultProps} />);
      expect(getByRole('button')).toBeTruthy();
    });

    it('displays card value when flipped', () => {
      const flippedCard = { ...mockCard, isFlipped: true };
      const { getByText } = render(
        <Card {...defaultProps} card={flippedCard} />
      );
      expect(getByText('A')).toBeTruthy();
    });
  });

  describe('User Interaction', () => {
    it('calls onCardClick when pressed and not flipped', () => {
      const { getByRole } = render(<Card {...defaultProps} />);
      fireEvent.press(getByRole('button'));
      expect(mockOnCardClick).toHaveBeenCalledWith(mockCard.id);
    });

    it('does not call onCardClick when card is already flipped', () => {
      const flippedCard = { ...mockCard, isFlipped: true };
      const { getByRole } = render(
        <Card {...defaultProps} card={flippedCard} />
      );
      fireEvent.press(getByRole('button'));
      expect(mockOnCardClick).not.toHaveBeenCalled();
    });
  });

  describe('Accessibility', () => {
    it('has correct accessibility role', () => {
      const { getByRole } = render(<Card {...defaultProps} />);
      expect(getByRole('button')).toBeTruthy();
    });

    it('provides accessibility label for flipped card', () => {
      const flippedCard = { ...mockCard, isFlipped: true };
      const { getByRole } = render(
        <Card {...defaultProps} card={flippedCard} />
      );
      const button = getByRole('button');
      expect(button.props.accessibilityLabel).toContain('revealed');
    });
  });
});
```

## When to Use This Skill

Use this skill when:
- Creating tests for a new component
- Adding test coverage to an existing component
- Refactoring tests to follow best practices
- Setting up test configuration for a new project
- Debugging failing tests

The skill ensures consistent test quality across the codebase and adherence to accessibility standards.
