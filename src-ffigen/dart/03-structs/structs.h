struct Coordinate {
  double latitude;
  double longitude;
};

struct Place {
  char* name;
  struct Coordinate coordinate;
};

char *hello_world(void);
char *hello_world_slice(void);
char *reverse(char* a0, unsigned int const a1);
void free_string(char* a0);
struct Coordinate *create_coordinate(double a0, double a1);
struct Place *create_place(struct Place* a0);
double distance(struct Coordinate a0, struct Coordinate a1);
char * print_name(char* a0);

