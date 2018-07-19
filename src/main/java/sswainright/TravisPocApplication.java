package sswainright;

import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import io.federecio.dropwizard.swagger.SwaggerBundleConfiguration;
import io.federecio.dropwizard.swagger.SwaggerBundle;
import sswainright.config.TravisPocConfiguration;
import sswainright.resources.PocResource;

public class TravisPocApplication extends Application<TravisPocConfiguration> {

    public static void main(final String[] args) throws Exception {
        new TravisPocApplication().run(args);
    }

    @Override
    public String getName() {
        return "travisPoc";
    }

    @Override
    public void initialize(final Bootstrap<TravisPocConfiguration> bootstrap) {
        bootstrap.addBundle(new SwaggerBundle<TravisPocConfiguration>() {
            @Override
            protected SwaggerBundleConfiguration getSwaggerBundleConfiguration(
                TravisPocConfiguration configuration) {
                return configuration.getSwaggerBundleConfiguration();
            }
        });
    }

    @Override
    public void run(final TravisPocConfiguration configuration,
        final Environment environment) {

        environment.jersey().register(new PocResource());
    }

}
