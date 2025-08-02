# Contributing to Kaabo

Thank you for your interest in contributing to Kaabo! This document provides guidelines for contributing to the project.

## Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/kaabo.git
   cd kaabo
   ```

2. **Install Flutter**
   - Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install)
   - Ensure Flutter 3.29.3 or later is installed

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Setup environment**
   - Copy `.env.example` to `.env`
   - Add your Cloudinary credentials

## Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format code
- Run `flutter analyze` to check for issues

## Testing

- Write tests for new features
- Ensure all tests pass: `flutter test`
- Maintain test coverage above 80%

## Pull Request Process

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Format code: `dart format .`
7. Commit changes: `git commit -m "Add your feature"`
8. Push to branch: `git push origin feature/your-feature`
9. Create a Pull Request

## Commit Messages

Use conventional commit format:
- `feat: add new feature`
- `fix: resolve bug`
- `docs: update documentation`
- `test: add tests`
- `refactor: improve code structure`

## Issues

- Use issue templates when reporting bugs or requesting features
- Provide detailed information and steps to reproduce
- Include screenshots when applicable

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help maintain a welcoming environment for all contributors