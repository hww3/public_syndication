import Public.Web;
import Public.Parser;
import Standards;

//! An XESN Description element.

static string _contents;


//! Construct either a blank Description element or parse one.
//! 
//! @param node
//!   nothing, or an XML2.Node to parse for an existing Description.
//! 
void create(void|XML2.Node node) {
  if (node &&
      (node->get_ns() == XESN.XMLNS) &&
      (node->get_node_name() == "description")) {
    contents(node->get_text());
  }
}

//! Get or set the contents of the Description element.
//! 
//! @param __contents
//!   set the contents of the Description element.
//!
//! @returns
//!   the current contents of the Description element.
//!
void|string contents(void|string __contents) {
  if (__contents)
    _contents = __contents;
  return _contents;
}

//! Render the Description into an XML2.Node
//!
//! @param node
//!   an XML2.Node containing the Description's parent element.
//!
//! @returns
//!   a new XML2.Node containing the Description.
//!
XML2.Node render(void|XML2.Node node) {
  if (!contents())
    throw(({ "XESN Description element contains no contents.\n", backtrace() }));

  if (!node) {
    node = XML2.new_node("description");
    node->add_ns(XESN.XMLNS, "xesn");
  }
  else {
    catch(node->get_root_node()->add_ns(XESN.XMLNS, "xesn"));
    node = node->new_child("xesn", "description", "");
  }
  node->set_ns(XESN.XMLNS);
  node->set_content(contents());
  return node;
}

//!
int `==(mixed test) {
  if ((object_program(test) == Public.Web.XESN.Description) &&
      contents() == test->contents())
    return 1;
}

//!
int `!=(mixed test) {
  return !`==(test);
}

//!
static string _sprintf() {
  return sprintf("Public.Web.XESN.Description(/* %O */)", contents());
}
