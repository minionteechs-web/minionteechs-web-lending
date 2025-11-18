# Contribution Guidelines

Thank you for your interest in contributing to MinionTechs Web Lending Protocol! This document outlines how to contribute effectively.

## Code of Conduct

- Be respectful and professional
- Focus on the issue, not personal attacks
- Welcome diverse perspectives
- Help others learn and grow

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork locally**: `git clone https://github.com/YOUR_USERNAME/minionteechs-web-lending.git`
3. **Create a feature branch**: `git checkout -b feature/your-feature-name`
4. **Make your changes** and commit regularly
5. **Push to your fork**: `git push origin feature/your-feature-name`
6. **Create a Pull Request** to the `develop` branch

## Development Setup

See [DEVELOPMENT.md](./DEVELOPMENT.md) for detailed setup instructions.

## Commit Message Guidelines

Use clear, descriptive commit messages:

```
feat: Add liquidation feature
fix: Resolve interest calculation bug
docs: Update deployment instructions
test: Add liquidation tests
refactor: Optimize interest calculation
chore: Update dependencies
```

Format: `<type>: <subject>` (max 50 chars)

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `test`: Tests
- `refactor`: Code refactoring
- `chore`: Build, dependencies, etc.

## Pull Request Process

1. **Update documentation** if you change functionality
2. **Add tests** for new features or bug fixes
3. **Ensure tests pass**: `forge test` and `npm run build`
4. **Update CHANGELOG.md** with your changes
5. **Request review** from maintainers

### PR Checklist

- [ ] Tests pass locally
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] No unnecessary dependencies added
- [ ] Commit messages are clear
- [ ] Changes are scoped to single feature

## Coding Standards

### Solidity

- Follow [Solidity Style Guide](https://docs.soliditylang.org/en/v0.8.19/style-guide.html)
- Use NatSpec comments for functions
- Include event documentation
- Test with `forge test`

```solidity
/// @notice Deposits collateral for the sender
/// @param token The ERC20 token to deposit
/// @param amount The amount to deposit
/// @dev Requires token approval before calling
function deposit(address token, uint256 amount) external nonReentrant {
    require(amount > 0, "Amount must be greater than 0");
    // Implementation
}
```

### TypeScript/React

- Use strict TypeScript mode
- Define interfaces for all props
- Add JSDoc for complex functions
- Use meaningful variable names
- Follow [Airbnb Style Guide](https://github.com/airbnb/javascript)

```tsx
/**
 * Deposit component for collateral
 * @param onSuccess Callback after successful deposit
 */
interface DepositProps {
  onSuccess?: (amount: string) => void
}

export function DepositForm({ onSuccess }: DepositProps) {
  // Implementation
}
```

## Testing Requirements

### Smart Contracts

- Minimum 80% code coverage
- Test happy paths and error cases
- Test boundary conditions
- Include integration tests

```bash
# Run tests
forge test -vvv

# Check coverage
forge coverage
```

### Frontend

- Test new components
- Test hook functionality
- Use React Testing Library

## Documentation

- Update README.md for user-facing changes
- Update DEVELOPMENT.md for development changes
- Add JSDoc comments to complex code
- Include example usage in comments

## Reporting Issues

### Bug Reports

Include:
- Clear description of the issue
- Steps to reproduce
- Expected behavior
- Actual behavior
- Environment (OS, Node version, etc.)
- Error messages/logs
- Minimal code example if possible

### Feature Requests

Include:
- Clear description of the feature
- Use case/motivation
- Proposed solution (if any)
- Alternatives considered
- Any potential concerns

## Security Issues

**Do not** open public issues for security vulnerabilities.

Instead:
1. Email security details to maintainers
2. Include proof of concept if possible
3. Allow time for patches before disclosure
4. Follow responsible disclosure guidelines

## Review Process

1. **Automated checks**: GitHub Actions tests must pass
2. **Code review**: At least one maintainer review required
3. **Feedback incorporation**: Address review feedback
4. **Merge**: Once approved, can be merged by maintainers

## Release Process

Releases follow [Semantic Versioning](https://semver.org/):

- `MAJOR.MINOR.PATCH`
- Update version in package.json and foundry.toml
- Update CHANGELOG.md
- Create GitHub release
- Tag in git

## Recognition

Contributors will be:
- Added to CONTRIBUTORS.md
- Recognized in release notes
- Thanked in README

## Questions?

- Check existing issues and PRs
- Read the documentation
- Ask in GitHub Discussions
- Contact maintainers

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for making this project better! 🙏
