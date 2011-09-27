import Public.Web;
import Public.Parser;
import Standards;

//! An ATOM.Author.

static string _name;
static array _xesn;

//! Construct either a blank Author element or parse one.
//! 
//! @param node
//!   nothing, or an XML2.Node to parse for an existing Author.
//! 
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == ATOM.XMLNS) &&
      (node->get_node_name() == "author")) {
    foreach(node->children(), object n) {
      if ((n->get_ns() == ATOM.XMLNS) &&
	  (n->get_node_name() == "name")) {
	_name = n->get_text();
#if constant(Public.Web.XESN)
      }
      if ((n->get_ns() == XESN.XMLNS) &&
	  (n->get_node_name() == "alias")) {
	if (!_xesn)
	  _xesn = ({});
	_xesn += ({ XESN.Alias(n) });
      }
      if ((n->get_ns() == XESN.XMLNS) &&
	  (n->get_node_name() == "description")) {
	if (!_xesn)
	  _xesn = ({});
	_xesn += ({ XESN.Description(n) });
      }
      if ((n->get_ns() == XESN.XMLNS) &&
	  (n->get_node_name() == "link")) {
	if (!_xesn)
	  _xesn = ({});
	_xesn += ({ XESN.Link(n) });
      }
#else
	break;
      }
#endif
    }
  }
}

//! Get or set the name of the Author.
//!
//! @param __name
//!   If present, set the name of the Author, or "" to remove.
//!
//! @returns
//!   A string containing the name of the Author.
//!
string name(void|string __name) {
  if (__name)
    if (__name == "")
      _name = 0;
    else
      _name = __name;
  return _name;
}

//! Get or set any XESN elements on the Author.
//!
//! @note
//!   requires Public.Web.XESN module to work.
//!
//! @param __xesn
//!   an array containing XESN elements.
//!
void|array xesn(void|array __xesn) {
#if constant(Public.Web.XESN)
  if (__xesn)
    _xesn = __xesn;
#endif
  if (_xesn && sizeof(_xesn))
    return _xesn;
}

//! Render the Author into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Author's parent element.
//!
//! @returns
//!   a new XML2.Node containing the Author.
//!
XML2.Node render(void|XML2.Node node) {
  if (!name())
    throw(({ "Cannot have an unnamed author.", backtrace() }));
  if (!node) {
    node = XML2.new_node("author");
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", "author", "");
  }
  node->set_ns(ATOM.XMLNS);
  node->new_child("atom", "name", name())
    ->set_ns(ATOM.XMLNS);
#if constant(Public.Web.XESN)
  if (xesn()) {
    catch(node->get_root_node()->add_ns(XESN.XMLNS, "xesn"));
    foreach(xesn(), object x)
      x->render(node);
  }
#endif
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Web.ATOM.Author) &&
      name() == test->name())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
static string _sprintf() {
  return sprintf("Public.Web.ATOM.Author(/* %O */)", name());
}
