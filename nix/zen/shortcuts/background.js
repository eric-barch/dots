// Each command's name is the part it toggles: sidebar, toolbar or both.
browser.commands.onCommand.addListener(name => {
  browser.zenLayout.toggle(name);
});
