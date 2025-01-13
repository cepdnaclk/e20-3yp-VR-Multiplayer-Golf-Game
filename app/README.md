# Welcome to your Expo app 👋

This is an [Expo](https://expo.dev) project created with [`create-expo-app`](https://www.npmjs.com/package/create-expo-app).

## Get started

1. Install dependencies

   ```bash
   npm install
   ```

2. Start the app

   ```bash
    npx expo start
   ```

In the output, you'll find options to open the app in a

- [development build](https://docs.expo.dev/develop/development-builds/introduction/)
- [Android emulator](https://docs.expo.dev/workflow/android-studio-emulator/)
- [iOS simulator](https://docs.expo.dev/workflow/ios-simulator/)
- [Expo Go](https://expo.dev/go), a limited sandbox for trying out app development with Expo

You can start developing by editing the files inside the **app** directory. This project uses [file-based routing](https://docs.expo.dev/router/introduction).

## Get a fresh project

When you're ready, run:

```bash
npm run reset-project
```

This command will move the starter code to the **app-example** directory and create a blank **app** directory where you can start developing.

## Learn more

To learn more about developing your project with Expo, look at the following resources:

- [Expo documentation](https://docs.expo.dev/): Learn fundamentals, or go into advanced topics with our [guides](https://docs.expo.dev/guides).
- [Learn Expo tutorial](https://docs.expo.dev/tutorial/introduction/): Follow a step-by-step tutorial where you'll create a project that runs on Android, iOS, and the web.

## Join the community

Join our community of developers creating universal apps.

- [Expo on GitHub](https://github.com/expo/expo): View our open source platform and contribute.
- [Discord community](https://chat.expo.dev): Chat with Expo users and ask questions.


## Branching Strategy

This repository follows a structured branching strategy to ensure efficient collaboration and maintain a clean version history. Please adhere to the following guidelines when working on this project:

### Main Branch

- The main branch is the production-ready branch and should always remain stable.
- Direct commits or unreviewed changes must not be pushed to the main branch.

### Feature Branches

For all new features or issues, create a branch following the naming convention:

```
features/<your-name>/<issue-number>
```

- Replace `<your-name>` with your GitHub username or your name.
- Replace `<issue-number>` with the issue number or a short description related to the feature.

**Example:**

If your name is JohnDoe and you are working on issue number 123, your branch name should be:

```
features/JohnDoe/123
```

### Workflow

#### Create a New Branch:

1. Always branch off from the latest version of the main branch.
2. Use the naming convention outlined above.

**Example:**

```bash
git checkout main
git pull origin main
git checkout -b features/JohnDoe/123
```

#### Commit Changes:

- Ensure your commits are clear and concise.
- Follow a consistent commit message style, such as:

```
[Feature] Add functionality for X
[Fix] Resolve issue Y
[Refactor] Update code for Z
```

#### Push to Remote:

Push your feature branch to the remote repository.

```bash
git push origin features/JohnDoe/123
```

#### Create a Pull Request:

- Open a Pull Request (PR) to merge your branch into the main branch.
- Provide a detailed description of the changes in the PR.

#### Code Review:

- Your changes will be reviewed by peers or maintainers.
- Address any feedback before merging the PR.

#### Merge:

- Once approved, the PR will be merged into the main branch by a maintainer.

### Important Notes

- Always sync your feature branch with the latest changes from main to avoid conflicts:

```bash
git fetch origin
git merge origin/main
```

- Avoid long-lived feature branches to minimize merge conflicts.
- Delete your feature branch after merging the PR to keep the repository clean:

```bash
git branch -d features/JohnDoe/123
```

By following this branching strategy, we can maintain a clean and organized development process.
