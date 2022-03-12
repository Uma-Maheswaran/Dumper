import 'package:flutter/material.dart';

class PathBar extends StatelessWidget implements PreferredSizeWidget {
  final List paths;
  final Function(int) onChanged;
  final IconData? icon;

  const PathBar({
    Key? key,
    required this.paths,
    required this.onChanged,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: paths.length,
          itemBuilder: (BuildContext context, int index) {
            String i = paths[index];
            List splited = i.split('/');
            if (index == 0) {
              return IconButton(
                icon: Icon(
                  icon ?? Icons.smartphone,
                  color: Colors.white
                ),
                onPressed: () => onChanged(index),
              );
            }
            return InkWell(
              onTap: () => onChanged(index),
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      '${splited[splited.length - 1]}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Icon(Icons.chevron_right);
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40.0);
}
