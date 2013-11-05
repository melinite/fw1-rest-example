component output="false" displayname="" accessors="true"  {

	property objectStore;

	public function init(required any fw){
		variables.fw = arguments.fw;
		return this;
	}

	public void function default (required any rc)
	{
		rc.lists = getObjectStore().getObjectsByProperty("type", "list");
		fw.renderData("json", rc.lists);
	}

	public void function create (required any rc)
	{
		param name="rc.name" default="";

		if (Trim(rc.name) == "") {
			fw.renderData("json", {error = "Name is required"});
		} else {
			var existingList = getObjectStore().getObjectByFilterFunction(function (object) {
				return object.type == "list" && object.name == rc.name;
			});
			if (isNull(existingList)) {
				var list = {};
				list["name"] = rc.name;
				list["type"] = "list";
				getObjectStore().setObject(list);
			}
			fw.renderData("json", list);
		}
	}

	public void function show (required any rc)
	{
		var list = getObjectStore().getObjectById(rc.id);
		if (isNull(list)) {
			return fw.renderData("json", {error = "List not found"}, 404);
		} else {
			var listItems = getObjectStore().getObjectsByProperty("listId", list.id);
			var result = {};
			result["list"] = list;
			result["listItems"] = listItems;
			fw.renderData("json", result);
		}
	}

}