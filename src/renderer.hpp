#pragma once

#include "gl_common.hpp"
#include "GLUtil/shader.hpp"

struct render_info;
struct options;

struct renderer
{
	renderer(const options& opts);

	int get_ret() const
	{
		return ret;
	}

	bool get_is_render() const
	{
		return is_render;
	}

    void partial_draw_fullscreen(const float coord_offset_x, const float coord_offset_y);
    void prepare_draw_particles(GLsizei i, GLsizei j, const render_info& ri);
    void partial_draw_particles(GLsizei k, const GLsizei num_particles_per_draw);

private:

	bool init_fullscreen_program(const options& opts);
	bool init_particle_program(const options& opts);
	

	int						ret;
	bool					is_render;
	GLUtil::scoped_program	program;
	GLUtil::scoped_program	particle_program;
    GLint                   coord_offset_loc    = -1;
    GLint                   viewport_offset_loc = -1;
    GLint                   vertexID_offset_loc = -1;
};

