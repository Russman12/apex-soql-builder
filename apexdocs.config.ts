import { defineMarkdownConfig, defineChangelogConfig, DocPageData } from "@cparra/apexdocs";
import * as fs from "node:fs";

function loadFileAsync(filePath: string): Promise<string> {
  return new Promise((resolve, reject) => {
    fs.readFile(filePath, "utf8", (err, data) => {
      if (err) {
        reject(err);
      } else {
        resolve(data);
      }
    });
  });
}

function writeFileAsync(filePath: string, data: string): Promise<void> {
  return new Promise((resolve, reject) => {
    fs.writeFile(filePath, data, (err) => {
      if (err) {
        reject(err);
      } else {
        resolve();
      }
    });
  });
}

export default {
  changelog: defineChangelogConfig({
    previousVersionDir: "previous",
    currentVersionDir: "force-app",
    scope: ["global", "public"],
    transformChangeLogPage: () => {
      return {
        frontmatter: {
          title: "Changelog"
        }
      };
    }
  }),
  markdown: defineMarkdownConfig({
    sourceDir: "force-app",
    includeMetadata: false,
    scope: ["global", "public"],
    sortAlphabetically: true,

    transformReference: (reference) => {
      return {
        // remove the trailing .md
        referencePath: reference.referencePath.replace(/\.md$/, "")
      };
    },
    transformReferenceGuide: async () => {
      const frontMatter = await loadFileAsync("./docs/index-frontmatter.md");
      return {
        content: "", // controls content below heading on landing page
        frontmatter: frontMatter
      };
    },
    exclude: ["**/*_Test.cls"],
    excludeTags: ["internal"],
    transformDocs: async (docs) => {
      const gettingStarted = { text: "Getting Started", link: "/getting-started.md" };
      const apexOnlyDocs = docs.filter((doc) => doc.type !== "customobject");
      const objectOnlyDocs = docs.filter((doc) => doc.type === "customobject");

      // Update sidebar
      const sidebar = [
        gettingStarted,
        {
          text: "API Reference",
          items: Array.from(extractGroups(apexOnlyDocs)).map(([groupName, groupDocs]) => ({
            text: groupName,
            items: groupDocs.map(toSidebarLink),
            collapsed: false
          }))
        },
        {
          text: "Object Reference",
          items: objectOnlyDocs.map(toSidebarLink)
        }
      ];
      await writeFileAsync("./docs/.vitepress/sidebar.json", JSON.stringify(sidebar, null, 2));

      return docs;
    },
    transformDocPage: async (docPage) => {
      return {
        ...docPage,
        frontmatter: {
          title: docPage.source.name
        }
      };
    }
  })
};

function toSidebarLink(doc: DocPageData) {
  return {
    text: doc.source.name,
    link: doc.outputDocPath
  };
}

function extractGroups(docs: DocPageData[]) {
  const groups = new Map<string, DocPageData[]>();
  for (const doc of docs) {
    if (!doc.group) {
      continue;
    }

    const groupDocs = groups.get(doc.group) ?? [];
    groupDocs.push(doc);
    groups.set(doc.group, groupDocs);
  }

  return groups;
}
