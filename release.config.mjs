export default {
  branches: ["main"],
  plugins: [
    "@semantic-release/commit-analyzer",
    [
      "@semantic-release/github",
      {
        assets: [
          {
            path: ".release/install.mjs",
            label: "Install script"
          }
        ]
      }
    ],
    [
      "@semantic-release/exec",
      {
        verifyReleaseCmd: "bash .release/create.sh ${nextRelease.version}",
        generateNotesCmd: "bash .release/generateNotes.sh",
        publishCmd: 'bash .release/publish.sh "${nextRelease.channel}"'
      }
    ],
    "@semantic-release/release-notes-generator"
  ]
};
