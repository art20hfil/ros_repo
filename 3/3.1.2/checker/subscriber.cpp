#include "ros/ros.h"
#include "visualization_msgs/Marker.h"
#include <string>
#include <fstream>

using namespace std;
using namespace ros;

class Handler {
	bool first_mes;
	string ns;
	int id;
	ofstream fout_marker;
public:
	Handler() : first_mes(true) {
		string output_file_name;
		param::param<string>("~output_file_name",output_file_name,string("output_marker.txt"));
		fout_marker.open(output_file_name.c_str());
	}

	void f(const visualization_msgs::Marker& msg) {
		static int i = 0;
		i++;
		if (first_mes) {
			ns = msg.ns;
			id = msg.id;
		}
		first_mes = false;
		fout_marker << "message " << i <<":";
		if (ns != msg.ns || id != msg.id) {
			fout_marker << endl << msg << endl
			            << "incorrect:" << endl
			            << "\tfirst message namespace was: '" << ns.c_str() << "'" << endl
			            << "\tfirst message        id was: " << id << endl
			            << "\tgot message namespace: '" << msg.ns.c_str() << "'" << endl
			            << "\tgot message        id: " << msg.id << endl;
			return;
		}
		if (msg.action != visualization_msgs::Marker::ADD) {
			fout_marker << endl << msg << endl
			            << "incorrect action: " << endl
			            << "\tcurrent: " << msg.action
			            << (msg.action == 0? " (ADD/MODIFY)": "")
			            << (msg.action == 2? " (DELETE)": "")
				    << (msg.action == 3? " (DELETEALL)": "") << endl
				    << "\trequested: " << "0 (ADD/MODIFY)" << endl;
			return;
		}
		if (msg.points.size() != 5) {
			fout_marker << endl << msg << endl
			            << "incorrect amount of points in set:" << endl
			            << "\tcurrent: " << msg.points.size() << endl
			            << "\trequested: " << 5 << endl;
			return;
		}
		if (msg.type != visualization_msgs::Marker::POINTS) {
			fout_marker << endl << msg << endl
			            << "incorrect type of set: " << endl
			            << "\tcurrent: " << msg.action
			            << (msg.action ==  0? " (ARROW)": "")
			            << (msg.action ==  1? " (CUBE)": "")
			            << (msg.action ==  2? " (SPHERE)": "")
			            << (msg.action ==  3? " (CYLINDER)": "")
			            << (msg.action ==  4? " (LINE_STRIP)": "")
			            << (msg.action ==  5? " (LINE_LIST)": "")
			            << (msg.action ==  6? " (CUBE_LIST)": "")
			            << (msg.action ==  7? " (SPHERE_LIST)": "")
			            << (msg.action ==  8? " (POINTS)": "")
			            << (msg.action ==  9? " (TEXT_VIEW_FACING)": "")
			            << (msg.action == 10? " (MESH_RESOURCE)": "")
			            << (msg.action == 11? " (TRIANGLE_LIST)": "") << endl
				    << "\trequested: " << "8 (POINTS)" << endl;
		}
		for (int i = 0; i < 5; i++) {
			fout_marker << " (" << msg.points[i].x << " " << msg.points[i].y << " " << msg.points[i].z << ")";
		}
		fout_marker << endl;
	}
};

int main(int argc, char** argv) {
	init(argc, argv, "marker_subscriber");
	NodeHandle n;
	Handler h;
	Subscriber s = n.subscribe("/output",10,&Handler::f, &h);
	spin();
	return 0;
}
