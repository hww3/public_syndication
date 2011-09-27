import Public.Web;
import Public.Parser;
import Standards;

//! An ATOM.Conent object.

static URI _uri;
static string _type;
static XML2.Node _inline;
static string _raw;

//! Create an ATOM.Content object.
//!
//! @param node
//!   an XML2.Node to parse for content.
//!
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == ATOM.XMLNS) &&
      (node->get_node_name() == "content")) {
    if (node->get_attributes()->uri) {
      _uri = URI(node->get_attributes()->uri);
      if (node->get_attributes()->type)
	_type = node->get_attributes()->uri;
    }
    else if (node->get_attributes()->type) {
      string type = node->get_attributes()->type;
      if (type == "text") {
	_type = "text";
	_raw = node->get_text();
      }
      else if (type == "html") {
	_type = "html";
	_raw = node->get_text();
      }
      else if (type == "xhtml") {
	_type = "xhtml";
	object div;
	foreach(node->children(), object n) {
	  if ((n->get_ns() == XHTML.XMLNS) &&
	      (n->get_node_name() == "div"))
	    div = n;
	}
	if (!div) 
	  throw(({ "Content element type set to XHTML but with no XHTML DIV child.", backtrace() }));
	_inline = div;
      }
      else if ((sizeof(type) > 4) && (type[0..3] == "text")) {
	_type = type;
	_raw = node->get_text();
      }
      if (has_suffix(type, "+xml") || has_suffix(type, "/xml")) {
	_type = type;
	_inline = node->children()[0]; // THis might be wrong, but a valid XML document should only have one root node.
      }
      if (!catch(string tmp = MIME.decode_base64(node->get_text()))) {
	_type = type;
	_raw = tmp;
      }
      else
	throw(({ "I'm not even sure if I can end up here!", backtrace() }));
    }
  }
}

//! Set new content.
//!
//! @param type
//!   the type of content to set, either "text", "html", "xhtml".
//!
//! @param it
//!   either a string containing some plain text or serialised html content, an XML2.Node containing an XHTML div element or a Standards.URI object which points to the remote content.
//!
void set(string type, string|XML2.Node|URI it) {
  _type = type;
  if (stringp(it)) {
    _raw = it;
    _inline = 0;
    _uri = 0;
  }
  else if (objectp(it)) {
    if (object_program(it) == URI) {
      _uri = it;
      _inline = 0;
      _raw = 0;
    }
    else {
      _raw = 0;
      _inline = it;
      _uri = 0;
    }
  }
}

//! Returns the type of content (either "text", "html" or "xhtml")
//!
string type() {
  return _type;
}

//! Returns the URI that points to remote content.
//!
void|URI src() {
  return _uri;
}

//! Returns any inline content (ie text, html or an XHTML node).
//!
void|string|XML2.Node content() {
  if (_raw)
    return _raw;
  if (_inline)
    return _inline;
}

//! Render the Content into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Content's parent element.
//!
//! @returns
//!   a new XML2.Node containing the Content.
//!
XML2.Node render(void|XML2.Node node) {
  if (!node) {
    node = XML2.new_node("content");
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", "content", "");
  }
  node->set_ns(ATOM.XMLNS);
  node->set_attribute("type", _type);
  if (_uri) {
    node->set_attribute("src", (string)_uri);
  }
  else {
    if (_inline) {
      catch(node->get_root_node()->add_ns(XHTML.XMLNS, "html"));
      node->add_child(_inline);
    }
    else if (_raw) 
      node->set_content(_raw);
  }
  return node;
}
