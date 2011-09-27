import Public.Parser;
import Public.Syndication;
import Standards;

//! An ATOM Entry element.

static URI _id;
static .HRText _title;
static .RFC3339 _updated;
static array _authors = ({});
static .Content _content;
static array _links = ({});
static .HRText _summary;
static array _categories;
static array _contributors;
static .RFC3339 _published;
static .Source _source;
static .HRText _rights;


//! Create an ATOM Entry element.
//!
//! @param node
//!   an XML2.Node to parse as an Entry.
//!
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == ATOM.XMLNS) &&
      (node->get_node_name() == "entry")) {
    foreach(node->children(), object n) {
      if (n->get_ns() == ATOM.XMLNS)
	switch(n->get_node_name()) {
	  case "id":
	    _id = URI(n->get_text());
	  break;
	  case "title":
	    _title = .HRText(n);
	  break;
	  case "updated":
	    _updated = .RFC3339(n->get_text());
	  break;
	  case "author":
	    add_author(.Author(n));
	  break;
	  case "content":
	    _content = .Content(n);
	  break;
	  case "link":
	    add_link(.Link(n));
	  break;
	  case "summary":
	    _summary = .HRText(n);
	  break;
	  case "category":
	    add_category(.Category(n));
	  break;
	  case "contributor":
	    add_contributor(.Contributor(n));
	  break;
	  case "published":
	    _published = .RFC3339(n->get_text());
	  break;
	  case "source":
	    _source = .Source(n);
	  break;
	  case "rights":
	    _rights = .HRText(n);
	  break;
	}
    }
  }
  else
    throw(({ sprintf("XML2.Node %O is not an ATOM entry", node), backtrace() }));
}

/* Required elements */

//! Gets and sets the URI for the Entry ID.
//!
//! @param __id
//!   A new URI to set the ID to.
//!
//! @note
//!   this is a required property.
//!
//! @returns
//!   a Standards.URI object.
//!
URI id(void|URI __id) {
  if (__id)
    _id = __id;
  return _id;
}

//! Get or set the Entry's Title.
//!
//! @param __title
//!   a new human readable text object to set.
//!
//! @note
//!   This is a required property.
//!
//! @returns
//!   a human readable text object.
//!
.HRText title(void|.HRText __title) {
  if (__title)
    _title = __title;
  return _title;
}

//! Get or set the time this Entry was updated in RFC3339 format.
//!
//! @param __updated
//!   an RFC3339 object.
//!
//! @note
//!   this is a required property.
//! 
//! @returns
//!   an RFC3339 object.
//! 
.RFC3339 updated(void|.RFC3339 __updated) {
  if (__updated)
    _updated = __updated;
  return _updated;
}

/* Recommended elements */

//! Add an Author element to the Entry.
//!
//! @param a
//!   an ATOM.Author object.
//!
//! @returns
//!   the number of Authors for this Entry.
//!
int add_author(.Author a) {
  if (!((multiset)_authors)[a])
    _authors += ({ a });
  return sizeof(_authors);
}

//! Remove an Author element from the Entry.
//! 
//! @param a
//!   an ATOM.Author object.
//!
//! @returns
//!   the number of Authors for this Entry.
//!
int rm_author(.Author a) {
  _authors -= ({ a });
  return sizeof(_authors);
}

//! Gets all the Authors on this Entry.
//!
//! @returns
//!   an array(ATOM.Author).
//!
//! @note
//!   this is a recommended property.
//! 
array authors() {
  return _authors;
}

//! Get or set the content for this Entry.
//! 
//! @param __content
//!   an ATOM.Content element.
//!
//! @returns
//!   an ATOM.Content element.
//!
//! @note
//!   this is a recommended property.
//! 
void|.Content content(void|.Content __content) {
  if (__content)
    _content = __content;
  return _content;
}

//! Add an Link element to the Entry.
//!
//! @param l
//!   an ATOM.Link object.
//!
//! @returns
//!   the number of Links for this Entry.
//!
int add_link(.Link l) {
  _links -= ({ l });
  _links += ({ l });
  return sizeof(_links);
}

//! Remove an Link element from the Entry.
//! 
//! @param a
//!   an ATOM.Link object.
//!
//! @returns
//!   the number of Links for this Entry.
//!
int rm_link(.Link l) {
  _links -= ({ l });
  return sizeof(_links);
}

//! Gets all the Link on this Entry.
//!
//! @returns
//!   an array(ATOM.Link).
//!
//! @note
//!   this is a recommended property.
//! 
array links() {
  return _links;
}

//! Get or set the summary for this Entry.
//!
//! @param _summary
//!   an ATOM.HRText instance containing the summary of this Entry.
//!
//! @returns
//!   an ATOM.HRText instance containing the summary of this Entry.
//!
//! @note
//!   this is a recommended property.
//! 
void|.HRText summary(void|.HRText __summary) {
  if (__summary)
    _summary = __summary;
  return _summary;
}

/* Optional elements */

//! Add a Category element to the Entry.
//!
//! @param c
//!   an ATOM.Category object.
//!
//! @returns
//!   the number of categories for this Entry.
//!
int add_category(.Category c) {
  _categories -= ({ c });
  _categories += ({ c });
  return sizeof(_categories);
}

//! Remove a Category element from the Entry.
//!
//! @param c
//!   an ATOM.Category object.
//!
//! @returns
//!   the number of categories for this Entry.
//!
int rm_category(.Category c) {
  _categories -= ({ c });
  return sizeof(_categories);
}

//! Gets all the categories on this Entry.
//!
//! @returns
//!   an array(ATOM.Category).
//!
array categories() {
  return _categories;
}

//! Add a Contributor element to the Entry.
//!
//! @param c
//!   an ATOM.Contributor object.
//!
//! @returns
//!   the number of contributors for this Entry.
//!
int add_contributor(.Contributor c) {
  _contributors -= ({ c });
  _contributors += ({ c });
  sizeof(_contributors);
}

//! Remove a Contributor element from the Entry.
//!
//! @param c
//!   an ATOM.Contributor object.
//!
//! @returns
//!   the number of contributors for this Entry.
//!
int rm_contributor(.Contributor c) {
  _contributors -= ({ c });
  return sizeof(_contributors);
}

//! Gets all the contributors on this Entry.
//!
//! @returns
//!   an array(ATOM.Contributor).
//!
array contributors() {
  return _contributors;
}

//! Get or set the published date on the Entry.
//!
//! @param __published
//!   an ATOM.RFC3339 instance containing the a new published time.
//!
//! @returns
//!   an ATOM.RFC3339 instance.
//!
void|.RFC3339 published(void|.RFC3339 __published) {
  if (__published)
    _published = __published;
  return _published;
}

//! Get or set a source element on the Entry.
//! 
//! @param __source
//!   an ATOM.Source instance.
//!
//! @returns
//!   an ATOM.Source instance.
//!
void|.Source source(void|.Source __source) {
  if (__source)
    _source = __source;
  return _source;
}

//! Get or set a rights element on the Entry.
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

//! Render the Entry into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Entries parent element.
//!
//! @returns
//!   a new XML2.Node containing the Entry.
//!
XML2.Node render(void|XML2.Node node) {
  if (!id())
    throw(({ "Entry element must contain an ID.\n", backtrace() }));
  if (!title())
    throw(({ "Entry element must contain a title.\n", backtrace() }));
  if (!updated())
    throw(({ "Entry element must contain a updated.\n", backtrace() }));

  if (!node) {
    node = XML2.new_node("entry");
    node->add_ns(ATOM.XMLNS, "atom");
  }
  else {
    catch(node->get_root_node()->add_ns(ATOM.XMLNS, "atom"));
    node = node->new_child("atom", "entry", "");
  }
  node->set_ns(ATOM.XMLNS);
  node->new_child("atom", "id", (string)id())
    ->set_ns(ATOM.XMLNS);
  title()->render(node);
  node->new_child("atom", "updated", updated()->render())
    ->set_ns(ATOM.XMLNS);
  if (authors())
    foreach(authors(), object a)
      a->render(node);
  if (content())
    content()->render(node);
  if (links() && sizeof(links()))
    foreach(links(), object l)
      l->render(node);
  if (summary())
    summary()->render(node);
  if (categories() && sizeof(categories()))
    foreach(categories(), object c)
      c->render(node);
  if (contributors() && sizeof(contributors()))
    foreach(contributors(), object c)
      c->render(node);
  if (published()) 
    node->new_child("atom", "published", published()->render())
      ->set_ns(ATOM.XMLNS);
  if (source())
    source()->render(node);
  if (rights())
    rights()->render(node);
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Syndication.ATOM.Entry) &&
      id() == test->id())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
static string _sprintf() {
  return sprintf("Public.Syndication.ATOM.Feed(/* %O, %O */)", title()->contents(), (string)id());
}
