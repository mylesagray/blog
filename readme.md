# Repo for blog

<https://blah.cloud>

## Todo

* [Images for graph services and Twitter](https://www.jannikarndt.de/blog/2021/05/generating_open_graph_images/)
* About page
* Works page
* ~~Redirect AMP URLs to new canonical URLs~~
* LD+JSON metadata
* ~~Convert images to webp~~ / ~~Resize images for mobile~~
  * <https://fundor333.com/post/2021/hugo-with-lazy-loading-and-webp/>
  * <https://pawelgrzybek.com/webp-and-avif-images-on-a-hugo-website/>
  * <https://stas.starikevich.com/posts/hugo-and-webp/>
  * <https://imageoptim.com/command-line.html>
  * <https://stackoverflow.com/a/15987280/571593>
    * Dynamically convert to webp with appropriate sizes using hugo, instead of manually doing it
* ~~Lazy load offscreen images~~
* ~~Hamburger menu for mobile~~
  * ~~Convert FontAwesome bar icon to SVG~~
* Tab-prompted search / XRDS / RFC7033 / host-meta
* `site.webmanifest`

```json
{"@type":"WebSite","@id":"https://blah.cloud/#website","url":"https://blah.cloud/","name":"Blah, Cloud.","description":"Adventures in architectures","publisher":{"@id":"https://blah.cloud/#/schema/person/65b4688619b5af7ea0c4497700f98718"},"potentialAction":[{"@type":"SearchAction","target":{"@type":"EntryPoint","urlTemplate":"https://blah.cloud/?s={search_term_string}"},"query-input":"required name=search_term_string"}],"inLanguage":"en-GB"}
```
