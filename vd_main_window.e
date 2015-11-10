note
	description	: "Main window for this demo application. Orginally authored by Emanuele Rudel, adjusted by Christian Estler."

class
	VD_MAIN_WINDOW

inherit
	EV_TITLED_WINDOW -- want the window to be a titled window
		redefine
			initialize
		end

	VD_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Creation procedure
		do
				-- Create the window and set its title
			make_with_title (window_title)
		end

	initialize
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}

				-- call procdure that will create the main container
				-- and add the drawing-area and the model world to it
			build_main_container
				-- add the container to this window
			extend (main_container)

				-- Execute `request_close_window' when the user clicks
				-- on the cross in the title bar.
			close_request_actions.extend (agent request_close_window)

				-- Set the title of the window
			set_title (Window_title)

				-- Set the initial size of the window
			set_size (Window_width, Window_height)
		end


feature {NONE} -- Implementation, Close event

	request_close_window
			-- The user wants to close the window
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text (Label_confirm_close_window)
			question_dialog.show_modal_to_window (Current)

			if question_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
				destroy
			end
		end


feature {NONE} -- Implementation

	main_container: EV_VERTICAL_BOX
			-- Main container (contains all widgets displayed in this window)

	area: EV_DRAWING_AREA
			-- Drawing area which the MODEL project will use to draw the MODEL on

	build_main_container
			-- Create and populate `main_container'.
		require
			main_container_not_yet_created: main_container = Void
		local
			l_projector: EV_MODEL_DRAWING_AREA_PROJECTOR
			l_world: EV_MODEL_WORLD
			l_pixmap: EV_PIXMAP
			l_bg: EV_PIXMAP
			l_tile: VD_TILE_VIEW
			l_bg_pic: EV_MODEL_PICTURE
			i: INTEGER
			l_buffer: EV_PIXMAP
		do
			create main_container

				-- Create an orange hex
			create l_pixmap
			l_pixmap.set_with_named_file (file_system.pathname_to_string (vd_img_stone))

				-- Create the background pixmap
			create l_bg
			l_bg.set_with_named_file (file_system.pathname_to_string (vd_img_background))

				-- Create background image for model world (base on l_bg pixmap)
			create l_bg_pic.make_with_pixmap (l_bg)

				-- Add background to the world. The last extended model is the one on the front!
				-- Therefore add the background first, and the other things later
			create l_world
			l_world.extend (l_bg_pic)

				-- Add a couple of tiles to the world
			from i := 1	until i > 3 loop
				create l_tile.make_with_hex (l_pixmap, l_pixmap)
				l_world.extend (l_tile)
				l_tile.set_point_position (40, 10 + 100*i)
				i := i + 1
			end
				-- Create the drawing area and assign a model projector to it
			create l_buffer.make_with_size (l_bg.width, l_bg.height)
			create area
			create l_projector.make_with_buffer (l_world, l_buffer, area)

				-- add the drawing area to the container
			main_container.extend (area)

				-- (Optional) Refresh the drawing area
			l_projector.project
		ensure
			main_container_created: main_container /= Void
		end


feature {NONE} -- Implementation / Constants


	Window_title: STRING = "Vision demo"
			-- Title of the window.

	Window_width: INTEGER = 500
			-- Initial width for this window.

	Window_height: INTEGER = 570
			-- Initial height for this window.


	pix_background: EV_PIXMAP
			-- returns the background for the active game
		once
			create Result
			Result.set_with_named_file (file_system.pathname_to_string (vd_img_background))
		end

	pix_stone: EV_PIXMAP
			-- returns the background for the active game
		once
			create Result
			Result.set_with_named_file (file_system.pathname_to_string (vd_img_stone))
		end


end
