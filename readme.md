## 📄 `README.md`


# 🛠️ Feature CLI Generator for Node.js Projects

This project is a **custom CLI tool** that helps you automatically create and register new features (like `auth`, `users`, `posts`, etc.) in a Node.js/Express app.

It handles:
- Creating feature folders
- Creating controller files
- Creating route files
- Auto-injecting the new route into your main `routes/index.js` file

This tool is designed for **local usage only**, without publishing to npm.

---

## 📁 Folder Structure Created

When you generate a feature (e.g. `auth`), it creates:


```
features/
└── auth/
├── auth.controller.js
└── auth.routes.js
```


And updates:



routes/index.js



---

## 📦 Packaging and Using the CLI

### 1. ✅ Prepare Your CLI Tool

Make sure your project contains the following:

- `make-feature.sh` → the Bash script that scaffolds the feature
- `package.json` with a name like `"bash-cli"` (or whatever you prefer)

### 2. ✅ Make the Script Executable

```bash
chmod +x make-feature.sh
````

---

### 3. 📦 Package the CLI Locally

In the CLI project folder:

```bash
npm pack
```

This will generate a `.tgz` file:

bash-cli-1.0.0.tgz

---

### 4. 📥 Install It in Your Target Project

Move or copy the `.tgz` file to your project:

```bash
cp bash-cli-1.0.0.tgz /path/to/your/project/
cd /path/to/your/project
npm install ./bash-cli-1.0.0.tgz
```

---

### 5. 🚀 Use the CLI in Your Project

Now you can generate a feature using `npx`:

```bash
npx bash-cli make-feature.sh <feature-name>
```

#### Example:

```bash
npx bash-cli make-feature.sh auth
```

This will:

* Create `features/auth/auth.controller.js`
* Create `features/auth/auth.routes.js`
* Inject `auth` into `routes/index.js`

✅ It also correctly mounts `/` for `auth` and `/feature-name` for other routes.

---

## 📤 Uninstall the CLI (Optional)

If you’re done using the CLI:

```bash
npm uninstall bash-cli
rm bash-cli-*.tgz
```

---

## 🧪 Example Workflow

```bash
# Step 1: Package your CLI
npm pack

# Step 2: Move it to your target project
mv bash-cli-1.0.0.tgz ../my-app/

# Step 3: Install it
cd ../my-app
npm install ./bash-cli-1.0.0.tgz

# Step 4: Use it to create a feature
npx bash-cli make-feature.sh gallery
```

---

## 📁 Sample Output

After running:

```bash
npx bash-cli make-feature.sh posts
```

Your app will look like:

```
features/
└── posts/
    ├── posts.controller.js
    └── posts.routes.js

routes/
└── index.js ← auto-updated
```

---

## 🙋 FAQ

### ❓ Do I need to publish this CLI to npm?

**No.** This tool is intended for **local use only**. Just package it with `npm pack` and use the `.tgz` file.

---

### ❓ Can I rename the CLI package?

Yes, update the `"name"` field in `package.json`, but be sure to match it when running `npx`.

---

### ❓ What if I run it twice for the same feature?

The script checks if the feature already exists in `routes/index.js` and skips injection to avoid duplication.

---

## 🚀 Ready to Use

This setup is perfect for:

* Scaffolding MVC structure for each feature
* Automating repetitive folder/file creation
* Keeping routes organized and registered automatically

---

Happy hacking! 🔧



---

Let me know if you'd like the same CLI to also generate:
- Views (EJS, Pug, etc.)
- Unit tests
- Models with Sequelize/Mongoose scaffolding

I can expand the script and README to support it.
