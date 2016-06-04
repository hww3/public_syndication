import Public.Syndication;
import Public.Parser;
import Standards;

//! An ATOM Source element.

protected URI _id;
protected .HRText _title;
protected .RFC3339 _updated;
protected .HRText _rights;

//! Create an ATOM Source element.
//!
//! @param node
//!   an XML2.Node to parse as a Source element.
//!
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == ATOM.XMLNS) &&
      (node->get_node_name() == "source")) {
    foreach(node->children(), object n) {
      if (n->get_ns() == ATOM.XMLNS) 
	switch (n->get_node_name()) {
	  case "id":
	    _id = URI(n->get_text());
	  break;
	  case "title":
	    _title = .HRText(n);
	  break;
	  case "updated":
	    _updated = .RFC3339(n->get_text());
	  break;
	  case "rights":
	    _rights = .HRText(n);
	  break;
	}
    }
  }
}

//! Gets and sets the URI for the Feed ID.
//!
//! @param __id
//!   A new URI to set the ID to.
//!
//! @returns
//!   a Standards.URI object.
//!
void|URI id(void|URI __id) {
  if (__id)
    _id = __id;
  return _id;
}

//! Get or set the Source's Title.
//!
//! @param __title
//!   a new human readable text object to set.
//!
//! @returns
//!   a human readable text object.
//!
void|.HRText title(void|.HRText __title) {
  if (__title)
    _title = __title;
  return _title;
}

//! Get or set the time this Source was updated in RFC3339 format.
//!
//! @param __updated
//!   an RFC3339 object.
//!
//! @returns
//!   an RFC3339 object.
//! 
void|.RFC3339 updated(void|.RFC3339 __updated) {
  if (__updated)
    _updated = __updated;
  return _updated;
}

//! Get or set a rights element on the Source.
//! 
//! @param __source
//!   an ATOM.HRText instance.
//!
//! @returns
//!   an ATOM.HRText instance.
//!
void|.HRText rights(void|.HRText __rights) {
  if (__rights)
    _rights = __rights;
  return _rights;
}

//! Render the Source into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Sources parent element.
//!
//! @returns
//!   a new XML2.Node containing the Source.
//!
XML2.Node render(void|XML2.Node node) {
  if (!node) {
    node = XML2.new_node("source");
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", "source", "");
  }
  node->set_ns(ATOM.XMLNS);
  node->new_child("atom", "id", (string)id())
    ->set_ns(ATOM.XMLNS);
  node->new_child("atom", "updated", updated()->render())
    ->set_ns(ATOM.XMLNS);
  title()->render(node);
  rights()->render(node);
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Syndication.ATOM.Source) &&
      id() == test->id())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
protected string _sprintf() {
  return sprintf("Public.Syndication.ATOM.Source(/* %O */)", id());
}
