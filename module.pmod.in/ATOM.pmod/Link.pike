import Public.Syndication;
import Public.Parser;
import Standards;

//! An ATOM.Link element.

protected URI _href;
protected string|Standards.URI _rel;
protected string _type;
protected string _hreflang;
protected string _title;
protected int _length;

//! Create an ATOM Link element.
//!
//! @param node
//!   an XML2.Node to parse as a Link.
//!
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == ATOM.XMLNS) &&
      (node->get_node_name() == "link")) {
    _href = URI(node->get_attributes()->href);
    if (node->get_attributes()->rel)
      if (!rel(node->get_attributes()->rel))
	catch(rel(Standards.URI(node->get_attributes()->rel)));
    if (node->get_attributes()->type)
      _type = node->get_attributes()->type;
    if (node->get_attributes()->hreflang)
      _hreflang = node->get_attributes()->hreflang;
    if (node->get_attributes()->title)
      _title = node->get_attributes()->title;
    if (node->get_attributes()->length)
      _length = (int)node->get_attributes()->length;
  }
}

//! Get or set the href attribute (destintation URI) of the Link.
//!
//! @param __href
//!   a Standards.URI instance containing the link target.
//!
//! @note
//!   this is a required attribute.
//!
URI href(void|URI __href) {
  if (__href)
    _href = __href;
  return _href;
}

//! Get or set the rel attribute of the Link.
//!
//! @param __rel
//!   one of the standard ATOM rel attributes or a Standards.URI instance.
//!
//! @returns
//!   the current contents of the rel attribute.
//!
void|string|Standards.URI rel(void|string|Standards.URI __rel) {
  if (__rel) {
    if (stringp(_rel)) 
      switch(__rel) {
	case "alternate":
	case "enclosure":
	case "related":
	case "self":
	case "via":
	  _rel = __rel;
	break;
	case "":
	  _rel = 0;
	break;
      }
    else if (objectp(__rel) && (object_program(__rel) == Standards.URI)) 
      _rel = __rel;
  }
  return _rel;
}

//! Get or set the MIME type of the Link.
//!
//! @param __type
//!   a new MIME type to set.
//!
//! @returns
//!   the current MIME type.
//!
void|string type(void|string __type) {
  if (__type)
    _type = __type;
  return _type;
}

//! Get or set the language of the Linked resource.
//!
//! @param __hreflang
//!   set the language of the Linked resource.
//!
//! @returns
//!   the current language of the Linked resource.
//!   
void|string hreflang(void|string __hreflang) {
  if (__hreflang)
    _hreflang = __hreflang;
  return _hreflang;
}

//! Get or set a short description of the Linked resource.
//!
//! @param __title
//!   set a description for the Linked resource.
//!
//! @returns
//!   the current description of the Linked resource.
//!   
void|string title(void|string __title) {
  if (__title)
    _title = __title;
  return _title;
}

//! Get or set the size (in bytes) of the Linked resource.
//!
//! @param __length
//!   set the size of the Linked resource.
//!
//! @returns
//!   the current size of the Linked resource.
//!   
void|int length(void|int __length) {
  if (__length)
    _length = __length;
  return _length;
}

//! Render the Link into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Link's parent element.
//!
//! @returns
//!   a new XML2.Node containing the Link.
//!
XML2.Node render(void|XML2.Node node) {
  if (!href())
    throw(({ "Link element contains no href attribute.", backtrace() }));
  if (!node) {
    node = XML2.new_node("link");
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", "link", "");
  }
  node->set_ns(ATOM.XMLNS);
  node->set_attribute("href", (string)href());
  if (rel())
    node->set_attribute("rel", rel());
  if (type())
    node->set_attribute("type", type());
  if (hreflang())
    node->set_attribute("hreflang", hreflang());
  if (title())
    node->set_attribute("title", title());
  if (length())
    node->set_attribute("length", (string)length());
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Syndication.ATOM.Link) &&
      href() == test->href())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
protected string _sprintf() {
  return sprintf("Public.Syndication.ATOM.Link(/* %O */)", (string)href());
}
