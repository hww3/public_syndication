import Public.Parser.XML2;

//!

  constant V10_NS = "http://purl.org/rss/1.0/";
  constant V20_NS = 0;
 
  string RSS_VER_CORE;

  static string type = "Thing";

  static multiset element_required_elements = (<>);
  static multiset element_subelements = (<>);

//!
  mapping data=([]);

  string version;

  void handle_ns_element_callback(string ns, string element, Node data, object thing);

  final string _sprintf(int m)
  {
    if(data && data->title)
      return type + "(" + (data->title||"") + ")";
    else return type + "(UNDEFINED)";
  }

  string get_element_text(Node xml)
  {
        return xml->get_text();
  }

  void set_version(string version)
  { 
    if(version="1.0") RSS_VER_CORE = V10_NS;
    else RSS_VER_CORE = 0;

    this->version = version;
  }

  void create(void|Node xml, void|string version)
  {
    // let's look at each element.

    if(version);
      set_version(version);

    if(xml == UNDEFINED) return;

    foreach(xml->children(); int index; Node child)
    {
      if(child && child->get_node_type() == 1)
      {
         string e = child->get_node_name();
         string v;
        if(child->get_ns() && child->get_ns()!=RSS_VER_CORE)
        {
          handle_ns_element(child, child->get_ns(), version);
        }
	else if(element_subelements[e])
        {
          if(this_object()["parse_" +e])
          {
            call_function(this_object()["parse_" +e], child, version);
          }
          else
          { 
            v = get_element_text(child);

            data[e] = v;

          }
        
          element_required_elements-=(<e>);
        }
        else
        {
          error("invalid subelement " + child->get_node_name() + " in " 
                + type + "\n");
        }
      }

    }
     if(sizeof(element_required_elements))
       error("Incomplete " + type + " definition: missing " + ((array)(element_required_elements)*" ") + "\n");
  }

  static void handle_ns_element(Node element, string ns, string version)
  {
    if(!data[ns])
     data[ns] = ([element->get_node_name(): element]);
    else data[ns][element->get_node_name()] = element;

    if(handle_ns_element_callback) handle_ns_element_callback(ns, element->get_node_name(), element, this);
  }

