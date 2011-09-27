import Public.Syndication;
import Public.Parser;
import Standards;

//! An XESN Link element.

static URI _href;
static array _rel;
static string _type;
static string _discovery;
static int _is_peer;
static int _is_avatar;

//! Allowed rel values.
constant REL_PEER = ({ "peer", "contact", "acquaintance", "friend", "met", "co-worker", "colleague", "co-resident", "neighbor", "child", "parent", "sibling", "spouse", "kin", "muse", "crush", "date", "sweetheart", "me" });

//! Create an XESN Link element.
//!
//! @param node
//!   an XML2.Node to parse as a Link.
//!
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == XESN.XMLNS) &&
      (node->get_node_name() == "link")) {
    if (node->get_attributes()->rel)
      rel(node->get_attributes()->rel);
    
    if (_rel && sizeof(_rel)) {
      multiset r = (multiset)_rel;
      if (is_peer()) {
	// We're a Peer link.
	type(node->get_attributes()->type);
	href(URI(node->get_attributes()->href));
	discovery(node->get_attributes()->discovery);
      }
      else if (is_avatar()) {
	// We're an Avatar link.
	type(node->get_attributes()->type);
	href(URI(node->get_attributes()->href));
	discovery(node->get_attributes()->discovery);
      }
    }
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

//! Get or set the discovery attribute of the Link.
//!
//! @param __discovery
//!   a string containing either "configured" or "automatic".
//!
//! @note
//!   this is a required attribute if the Link is a Peer link.
//!
void|string discovery(void|string __discovery) {
  if (_rel && sizeof(_rel) && (_rel[0] == "peer")) {
    if (__discovery &&
	((lower_case(__discovery) == "configured") ||
	 (lower_case(__discovery) == "automatic")))
      _discovery = __discovery;
    return _discovery;
  }
}

//! Get or set the rel attribute of the Link.
//!
//! @param __discovery
//!   a string containing a space separated list of rel values.
//!
//! @note
//!   this is a required attribute.
//!
void|string rel(void|string __rel) {
  if (__rel) {
    __rel = lower_case(__rel);
    if (__rel == "")
      _rel = 0;
    else {
      multiset r = (multiset)(__rel / " ");
      if (r->peer) {
	_is_peer = 1;
	_is_avatar = 0;
	_rel = ({ "peer" });
	array _r = (__rel / " ") - ({ "peer" });
	if (sizeof(_r)) {
	  array wrong = _r - REL_PEER;
	  if (sizeof(wrong))
	    throw(({ sprintf("Unknown rel value %O\n", wrong[0]), backtrace() }));
	  if (sizeof(wrong) > 1)
	    throw(({ sprintf("Unknown rel values %O\n", wrong * " "), backtrace() }));
	  else
	    _rel += _r;
	}
      }
      else if (r->avatar) {
	_is_avatar = 1;
	_is_peer = 0;
	_rel = ({ "avatar" });
      }
    }
  }
  if (_rel)
    return _rel * " ";
}

//! Is the Link a Peer Link?
//!
//! @returns
//!   void or a multiset of current rel values.
//!
void|multiset is_peer() {
  if (_is_peer)
    return (multiset)_rel;
}

//! Is the Link an Avatar Link?
//!
//! @returns
//!   0 or 1.
//!
int is_avatar() {
  return _is_avatar;
}

//! Gets or sets the MIME type of the Link element.
//!
//! @param __type
//!   a string containing the MIME type to set.
//!
//! @returns
//!   a string containing the current MIME type.
//!
void|string type(void|string __type) {
  if (__type) {
    if (_rel && sizeof(_rel) && _rel[0]) {
      if ((is_peer()) &&
	  ((__type == "application/atom+xml") ||
	   (__type == "application/rss+xml")))
	_type = __type;
      else if ((is_avatar()) &&
	  ((__type == "image/png") ||
	   (__type == "image/gif") ||
	   (__type == "image/jpeg") ||
	   (__type == "image/svg") ||
	   (__type == "application/svg+xml")))
	_type = __type;
      else if (is_peer())
	throw(({ sprintf("MIME type %O is invalid for a Peer link.\n", __type), backtrace() }));
      else
	throw(({ sprintf("MIME type %O is invalid for an Avatar link.\n", __type), backtrace() }));
    }
  }
  return _type;
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
    throw(({ "XESN Link element contains no href attribute.\n", backtrace() }));
  if (!rel())
    throw(({ "XESN Link element contains no rel attribute.\n", backtrace() }));
  if (!type())
    throw(({ "XESN Link element contains no type attribute.\n", backtrace() }));
  if (is_peer() && (!discovery()))
    throw(({ "XESN Link element contains no discovery attribute.\n", backtrace() }));

  if (!node) {
    node = XML2.new_node("link");
    node->add_ns(XESN.XMLNS, "xesn");
  }
  else {
    catch(node->get_root_node()->add_ns(XESN.XMLNS, "xesn"));
    node = node->new_child("xesn", "link", "");
  }
  node->set_ns(XESN.XMLNS);
  node->set_attribute("rel", rel());
  if (is_peer())
    node->set_attribute("discovery", discovery());
  node->set_attribute("href", (string)href());
  node->set_attribute("type", type());
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Syndication.XESN.Link) &&
      href() == test->href())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
static string _sprintf() {
  if (is_peer()) {
    return sprintf("Public.Syndication.XESN.Link(/* Peer:%O */)", (string)href());
  }
  else if (is_avatar()) {
    return sprintf("Public.Syndication.XESN.Link(/* Avatar:%O */)", (string)href());
  }
  else
    return "Public.Syndication.XESN.Link(/* Broken Link Element */)";
}
