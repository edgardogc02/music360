getOS = ->
  OSName = "Unknown";

  if navigator.appVersion.indexOf("Win") != -1 then OSName = "windows";
  if navigator.appVersion.indexOf("Mac") != -1 then OSName = "osx";
  if navigator.appVersion.indexOf("X11") != -1 then OSName = "unix";
  if navigator.appVersion.indexOf("Linux") != -1 then OSName = "linux";

  return OSName

createOSLink = (os) ->
  "/download-#{os}"

$ ->
  $(".download-os").attr("href", createOSLink(getOS()))
