import Public.Syndication;
import Public.Parser;
import Standards;

//! ATOM's human readable text elements.

constant TEXT_PLAIN = 1;
constant TEXT_HTML = 2;
constant TEXT_XHTML = 3;

static int _type;
static string|XML2.Node _text;
static string _xhtmlns = "http://www.w3.org/1999/xhtml";
static string _tag_name;

//! Create an ATOM human readable text element.
//!
//! @note
//!   ATOM's human readable text isn't really very nice, so here's the URI of the spec: http://www.atomenabled.org/developers/syndication/#text
//!
//! @param node
//!   an XML2.Node to parse as a HRText.
//!
void create(void|XML2.Node node) {
  if (node && (node->get_ns() == ATOM.XMLNS)) {
    _tag_name = node->get_node_name();
    switch(node->get_attributes()->type) {
      case "html":
	_type = TEXT_HTML;
	_text = node->get_text();
      break;
      case "xhtml":
	_type = TEXT_XHTML;
	foreach(node->children(), object n) {
	  if ((n->get_ns() == _xhtmlns) &&
	      (n->get_node_name() == "div")) {
	    _text = n;
	  }
	}
	if (!_text)
	  throw(({ "Syntax Error: Human readable text of type XHTML must contain a single XHTML DIV element", backtrace() }));
      break;
      case "text":
      default:
	_type = TEXT_PLAIN;
	_text = node->get_text();
      break;
    }
  }
}

//! Get or set the name of the human readable text tag (usually, "title", "summary", "content", "rights", etc).
//!
//! @param __tag_name
//!   set the name of the tag.
//!
//! @returns
//!   the current name of the tag.
//!
string tag_name(void|string __tag_name) {
  if (__tag_name)
    _tag_name = __tag_name;
  return _tag_name;
}

//! Set the type of content contained within the HRText.
//!
//! @param __type
//!   either TEXT_PLAIN, TEXT_HTML or TEXT_XHTML (see this module's constants).
//!
//! @note
//!   if you change the type of an existing HRText element it will have the side-effect of clearing any contents the HRText may have contained.
//!
int type(void|int __type) {
  if (__type && __type != _type) {
    _type = __type;
    _text = 0;
  }
  return _type;
}

//! Get or set the contents of the HRText element.
//!
//! @param __text
//!   either a string containing new contents (type must be TEXT_PLAIN or TEXT_HTML) or an XML2.Node containing an XHTML DIV element (type must be TEXT_XHTML).
//!
//! @returns
//!   the current contents of the HRText.
//!
string|XML2.Node contents(void|string|XML2.Node __text) {
  if (__text) {
    if (stringp(__text)) {
      if (type() != TEXT_XHTML) 
	_text = __text;
      else
	throw(({ "Cannot set contents to string when XHTML type is selected.", backtrace() }));
    }
    else if (objectp(__text)) {
      if (type() == TEXT_XHTML) {
	if ((__text->get_ns() == _xhtmlns) &&
	    (__text->get_node_name() == "div"))
	  _text = __text;
	else 
	  throw(({ "Contents can only contain a single XHTML DIV element when type is XHTML.", backtrace() }));
      }
      else
	throw(({ "Cannot set contents to XML2 node when XHTML type is not selected.", backtrace() }));
    }
  }
  return _text;
}

//! Render the HRText into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the parent element.
//!
//! @returns
//!   a new XML2.Node.
//!
XML2.Node render(void|XML2.Node node) {
  if (!node) {
    node = XML2.new_node(tag_name());
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", tag_name(), "");
  }
  node->set_ns(ATOM.XMLNS);
  if (type() == TEXT_HTML) {
    node->set_attribute("type", "html");
    node->set_content(contents()||"");
  }
  else if (type() == TEXT_XHTML) {
    catch(node->get_root_node()->add_ns(XHTML.XMLNS, "html"));
    node->set_attribute("type", "xhtml");
    node->add_child(contents());
  }
  else if (type() == TEXT_PLAIN) {
    node->set_attribute("type", "text");
    node->set_content(contents()||"");
  }
  return node;
}
