import Public.Web;
import Public.Parser;
import Standards;

//! An ATOM Generator element.

static void|URI _uri = URI("http://modules.gotpike.org/blahblah/Public.Web.ATOM");
static string _version = sprintf("%d.%d", ATOM.MAJOR, ATOM.MINOR);
static string _contents = sprintf("Public.Web.ATOM (%s)", predef::version());

//! Create an ATOM Generator element.
//!
//! @param node
//!   an XML2.Node to parse as a Generator.
//!
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == ATOM.XMLNS) &&
      (node->get_node_name() == "generator")) {
    if (node->get_attributes()->uri)
      _uri = URI(node->get_attributes()->uri);
    if (node->get_attributes()->version)
      _version = node->get_attributes()->version;
    _contents = node->get_text();
  }
}

//! Gets and sets the URI for the Generator URI.
//!
//! @param __uri
//!   A new URI to set the Generator URI to.
//!
//! @returns
//!   a Standards.URI object.
//!
void|URI uri(void|URI __uri) {
  if (__uri) 
    _uri = __uri;
  return _uri;
}

//! Gets and sets the version for the Generator.
//!
//! @param __version
//!   a new version string to set.  The ATOM spec is ambiguous in this instance and it is presumed you can use any freeform text, however since version is an attribute of Generator it's presumed that it should be kept fairly simple.
//!
//! @returns
//!   a string, duh.
//!
void|string version(void|string __version) {
  if (__version)
    _version = __version;
  return _version;
}

//! Gets and sets the contents of the Generator element.
//!
//! @param __contents
//!   new contents to set.  The ATOM spec is ambiguous in this instance and it is presumed you can use any freeform text, however as it is not flagged as "human readable" it cannot contain any tags or other markup.
//!
//! @returns
//!   a string, duh.
//!
string contents(void|string __contents) {
  if (__contents)
    _contents = __contents;
  return _contents;
}

//! Render the Generator into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Entries parent element.
//!
//! @returns
//!   a new XML2.Node containing the Feed.
//!
XML2.Node render(void|XML2.Node node) {
  if (!node) {
    node = XML2.new_node("generator");
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", "generator", "");
  }
  node->set_ns(ATOM.XMLNS);
  if (uri())
    node->set_attribute("uri", (string)uri());
  if (version())
    node->set_attribute("version", version());
  node->set_content(contents());
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Web.ATOM.Generator) &&
      contents() == test->contents())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
static string _sprintf() {
  return sprintf("Public.Web.ATOM.Generator(/* %O */)", contents());
}
