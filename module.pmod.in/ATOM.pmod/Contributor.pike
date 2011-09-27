import Public.Syndication;
import Public.Parser;
import Standards;

static string _name;
static array _xesn;

// An ATOM Contributor element.

//! Create an ATOM.Contributor element.
//!
//! @param node
//!   an XML2.Node to parse for Contributors.
//!
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == ATOM.XMLNS) &&
      (node->get_node_name() == "contributor")) {
    foreach(node->children(), object n) {
      if ((n->get_ns() == ATOM.XMLNS) &&
	  (n->get_node_name() == "name")) {
	_name = n->get_text();
#if constant(Public.Syndication.XESN)
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

//! Get or set the name of the contributor.
//!
//! @param __name
//!   A new name to set for the contributor, or "" to remove.
//!
//! @returns
//!   A string containing the name of the contributor.
//!
string name(void|string __name) {
  if (__name)
    if (__name == "")
      _name = 0;
    else
      _name = __name;
  return _name;
}

//! Get or set any XESN elements on the Contributor.
//!
//! @note
//!   requires Public.Syndication.XESN module to work.
//!
//! @param __xesn
//!   an array containing XESN elements.
//!
void|array xesn(void|array __xesn) {
#if constant(Public.Syndication.XESN)
  if (__xesn)
    _xesn = __xesn;
#endif
  if (sizeof(_xesn))
    return _xesn;
}

//! Render the Contributor into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Contributor's parent element.
//!
//! @returns
//!   a new XML2.Node containing the Contributor.
//!
XML2.Node render(void|XML2.Node node) {
  if (!name())
    throw(({ "Cannot have an unnamed contributor.", backtrace() }));
  if (!node) {
    node = XML2.new_node("contributor");
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", "contributor", "");
  }
  node->set_ns(ATOM.XMLNS);
  node->new_child("atom", "name", name());
#if constant(Public.Syndication.XESN)
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
  if ((object_program(test) == Public.Syndication.ATOM.Contributor) &&
      name() == test->name())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
static string _sprintf() {
  return sprintf("Public.Syndication.ATOM.Contributor(/* %O */)", name());
}
